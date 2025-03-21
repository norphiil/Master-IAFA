from numpy.fft import fft2, ifft2
import numpy as np
import matplotlib.pyplot as plt

# # I. Image et domaine spectral

# # Charger l'image
# image = plt.imread('assets/lena.jpg')

# # Afficher l'image
# plt.imshow(image, cmap='gray')
# plt.show()


def fourierImage(image):
    return np.log10(np.abs(np.fft.fft2(image)))


# # Afficher la magnitude sur une échelle logarithmique
# plt.imshow(fourierImage(image), cmap='gray')
# plt.axis('off')
# plt.show()

# # II. Localisation des hautes et des basses fréquences

# # Charger l'image
image = plt.imread('assets/lena.jpg')


def supprimer_coefficients_rectangulaire(img, pourcentage):
    f = np.fft.fft2(img)
    rows, cols = img.shape
    crow, ccol = rows // 2, cols // 2
    rect_size = int(np.sqrt(pourcentage) * rows / 2)
    start_row = crow - rect_size
    end_row = crow + rect_size
    start_col = ccol - rect_size
    end_col = ccol + rect_size
    f[start_row:end_row, start_col:end_col] = 0
    img_back = np.fft.ifft2(f).real
    return f, img_back


def supprimer_coefficients_bords(img, pourcentage):
    f = np.fft.fft2(img)
    rows, cols = img.shape
    crop_rows = int((pourcentage) * rows / 2)
    crop_cols = int((pourcentage) * cols / 2)
    indices_rows = np.arange(crop_rows, rows - crop_rows)
    indices_cols = np.arange(crop_cols, cols - crop_cols)
    new_f = np.zeros(img.shape, dtype=complex)
    new_f[indices_rows[:, None],
          indices_cols] = f[indices_rows[:, None], indices_cols]
    img_back = np.fft.ifft2(new_f).real
    return new_f, img_back


def getMagnitudeImage(f):
    magnitude = np.abs(f)
    magnitude_image = np.log(1 + magnitude)
    return magnitude_image


def showImageDelCoef(image, pourcentage):
    f_rect, img_back_rect = supprimer_coefficients_rectangulaire(
        image, pourcentage)
    f_bord, img_back_bord = supprimer_coefficients_bords(image, pourcentage)

    fig, (axis) = plt.subplots(2, 3, figsize=(15, 5))
    axis[0][0].imshow(image, cmap='gray')
    axis[0][1].imshow(getMagnitudeImage(f_rect), cmap='gray')
    axis[0][2].imshow(np.uint8(np.abs(img_back_rect)), cmap='Greys_r')
    axis[1][0].imshow(image, cmap='gray')
    axis[1][1].imshow(getMagnitudeImage(f_bord), cmap='gray')
    axis[1][2].imshow(np.uint8(np.abs(img_back_bord)), cmap='Greys_r')

    for axs in axis:
        for ax in axs:
            ax.axis('off')

    plt.show()


# showImageDelCoef(image, 0.05)

# # Les basses fréquences sont localisées dans le centre de l'image,
# # les haute fréquences sont localisées sur les bords de l'image.

# showImageDelCoef(image, 0.96)

# # A partir de 96% de supression des basses fréquences, l'image commence a ne plus etre reconnaissable

# lpf = np.ones((5, 5), dtype=np.float32)/25
# img_lpf = np.real(np.fft.ifft2(np.fft.fft2(image)
#                   * np.fft.fft2(lpf, image.shape)))

# hpf = np.array([[-1, -1, -1], [-1, 8, -1], [-1, -1, -1]], dtype=np.float32)
# img_hpf = np.abs(np.real(np.fft.ifft2(
#     np.fft.fft2(img_lpf) * np.fft.fft2(hpf, image.shape))))

# fig, axs = plt.subplots(1, 3)
# axs[0].imshow(image, cmap='gray')
# axs[0].set_title('Image originale')
# axs[1].imshow(img_lpf, cmap='gray')
# axs[1].set_title('Image atténuée')
# axs[2].imshow(img_hpf, cmap='gray')
# axs[2].set_title('Contours de l\'image')

# for ax in axs:
#     ax.axis('off')

# plt.show()

# # III. Réduction du bruit dans une image


# # Charger l'image
image = plt.imread('assets/lena.jpg')


def createNoiseImage(img):
    noise_mask = np.random.choice(
        [0, 1, 2], size=img.shape, p=[0.95, 0.025, 0.025])
    img_noisy = img.copy()
    img_noisy[noise_mask == 1] = 0
    img_noisy[noise_mask == 2] = 255
    return img_noisy


def fft_filter(img, threshold=0.1):
    fft_img = fft2(img)
    freq_x = np.fft.fftfreq(img.shape[0], 1)
    freq_y = np.fft.fftfreq(img.shape[1], 1)
    dist = np.sqrt(freq_x[:, np.newaxis]**2 + freq_y[np.newaxis, :]**2)
    mask = dist <= threshold
    filtered_fft_img = fft_img * mask
    filtered_img = np.real(ifft2(filtered_fft_img))
    filtered_img = (filtered_img - np.min(filtered_img)) / \
        (np.max(filtered_img) - np.min(filtered_img)) * 255
    filtered_img = filtered_img.astype(np.uint8)
    return filtered_img


img_noisy = createNoiseImage(image)
f_bord, img_back_bord = supprimer_coefficients_rectangulaire(
    img_noisy, 0.90)
# Afficher les images
fig, axs = plt.subplots(1, 2)
axs[0].imshow(img_noisy, cmap='gray')
axs[0].set_title('Image bruitée')
axs[1].imshow(img_back_bord, cmap='gray')
axs[1].set_title('Image débruitée')

for ax in axs:
    ax.axis('off')

plt.show()


def median_filter(img):
    img_filtered = np.copy(img)
    for i in range(1, img.shape[0] - 1):
        for j in range(1, img.shape[1] - 1):
            neighbors = img[i - 1:i + 2, j - 1:j + 2].ravel()
            sorted_neighbors = np.sort(neighbors)
            img_filtered[i, j] = sorted_neighbors[4]
    return img_filtered


# # Afficher les images
# fig, axs = plt.subplots(1, 3)
# axs[0].imshow(img_noisy, cmap='gray')
# axs[0].set_title('Image bruitée')
# axs[1].imshow(fft_filter(img_noisy), cmap='gray')
# axs[1].set_title('Image débruitée fft')
# axs[2].imshow(median_filter(img_noisy), cmap='gray')
# axs[2].set_title('Image débruitée median')

# for ax in axs:
#     ax.axis('off')

# plt.show()
