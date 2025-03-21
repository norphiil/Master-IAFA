#include <stdio.h>
#include <stdlib.h>
#include <string.h>

__global__ void vecADDKernel(unsigned int *d_vec, int n)
{
    int index = blockIdx.x * blockDim.x + threadIdx.x;
    for (int offset = n / 2; offset > 1; offset = offset / 2)
    {
        if (index < offset)
        {
            d_vec[index] += d_vec[index + offset];
        }
        __syncthreads();
    }
}

void vecADD(unsigned int *vec, int n)
{
    int bsize = 1024;
    int gsize = ((n + bsize - 1) / bsize);
    int vecSize = n * sizeof(unsigned int);
    unsigned int *d_vec;
    cudaMalloc((void **)&d_vec, vecSize);
    cudaMemcpy(d_vec, vec, vecSize, cudaMemcpyHostToDevice);
    vecADDKernel<<<gsize, bsize>>>(d_vec, n);
    cudaMemcpy(vec, d_vec, vecSize, cudaMemcpyDeviceToHost);
    cudaFree(d_vec);
}

int main(int argc, char **argv)
{
    int n = 1024;
    FILE *ptr;
    unsigned int vec[n];
    ptr = fopen("result.txt", "r");

    if (NULL == ptr)
    {
        printf("file can't be opened \n");
    }

    int i = 0;
    while (!feof(ptr))
    {
        vec[i] = (int)fgetc(ptr);
        i++;
    }
    fclose(ptr);

    vecADD(vec, n);

    printf("%i ", vec[0]);
}