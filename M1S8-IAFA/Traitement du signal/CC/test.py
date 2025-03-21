import numpy as np
import matplotlib.pyplot as plt
from scipy import signal


def getFiltredImage(image: np.ndarray, seuil: list[float], dim: list[int] = [2], sup: list[bool] = [True]) -> np.ndarray:
    final_image = image.copy()
    for d in range(len(dim)):
        if sup[d]:
            masque = (final_image[:, :, dim[d]] > seuil[d])
        else:
            masque = (final_image[:, :, dim[d]] < seuil[d])
        imgf = np.zeros(final_image.shape, dtype=np.uint8)
        imgf[masque, 0] = final_image[masque, 0]
        imgf[masque, 1] = final_image[masque, 1]
        imgf[masque, 2] = final_image[masque, 2]
        final_image = imgf
    return imgf


laplacian = np.array([[0, 1, 0], [1, -4, 1], [0, 1, 0]])

image = plt.imread('assets/drapeau_Italie.jpg')

fig, axes = plt.subplots(1, 3, figsize=(15, 5))
axes[0].imshow(image)
axes[0].set_title('Image originale')
axes[2].imshow(getFiltredImage(image=image, seuil=[100], dim=[1], sup=[True]))
axes[2].set_title('Image filtrée')

for ax in axes:
    ax.set_axis_off()

plt.show()
# plt.savefig('assets/drapeau_Italie_green.jpg')
