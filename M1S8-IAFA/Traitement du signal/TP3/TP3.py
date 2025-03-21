import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import convolve2d

# # Charger l'image
image = plt.imread('lena.jpg')

# # I. Filtre passe-bas et convolution


def convolution(image, filtre):
    h, w = image.shape
    fh, fw = filtre.shape
    padh, padw = (fh - 1) // 2, (fw - 1) // 2
    padded = np.pad(image, ((padh, padh), (padw, padw)))
    resultat = np.zeros(image.shape)
    for i in range(h):
        for j in range(w):
            subimage = padded[i:i + fh, j:j + fw]
            resultat[i, j] = np.sum(subimage * filtre)
    return resultat

# def convolution(image, filtre):
#     resultat = np.zeros(image.shape)
#     for i in range(image.shape[0]):
#         for j in range(image.shape[1]):
#             for k in range(filtre.shape[0]):
#                 for l in range(filtre.shape[1]):
#                     if i - k >= 0 and j - l >= 0:
#                         resultat[i, j] += image[i - k, j - l] * filtre[k, l]
#     return resultat


def passe_bas_binomial(n):
    if n < 2:
        raise ValueError(
            "La taille du filtre doit être supérieure ou égale à 2")

    coeffs = np.zeros(n)
    coeffs[0] = 1
    for i in range(1, n):
        coeffs[i] = coeffs[i - 1] * (n - i) // i

    filter_1d = coeffs / np.sum(coeffs)
    filter_2d = np.outer(filter_1d, filter_1d)

    return filter_2d


# # Application du filtre à l'image
# filtered_img_pb_3 = convolution(image, passe_bas_binomial(3))
# filtered_img_pb_5 = convolution(image, passe_bas_binomial(5))
# filtered_img_pb_conv = convolve2d(image, passe_bas_binomial(5))

# # Affichage de l'image originale et de l'image filtrée
# fig, axes = plt.subplots(1, 4, figsize=(10, 5))
# axes[0].imshow(image, cmap='gray', vmin=0, vmax=255)
# axes[0].set_title('Image originale')
# axes[1].imshow(filtered_img_pb_3, cmap='gray', vmin=0, vmax=255)
# axes[1].set_title('Image filtrée passe-bas 3x3')
# axes[2].imshow(filtered_img_pb_5, cmap='gray', vmin=0, vmax=255)
# axes[2].set_title('Image filtrée passe-bas 5x5')
# axes[3].imshow(filtered_img_pb_conv, cmap='gray', vmin=0, vmax=255)
# axes[3].set_title('Image filtrée passe-bas convolve2d')

# for ax in axes:
#     ax.axis('off')

# plt.show()

# # II. Filtre passe-haut et convolution


def pass_haut_filter(n):
    if n == 3:
        return np.array([[-1, -1, -1], [-1, 9, -1], [-1, -1, -1]])
    else:
        return np.array([[-1, -1, -1, -1, -1],
                         [-1, 0, 0, 0, -1],
                         [-1, 0, 32, 0, -1],
                         [-1, 0, 0, 0, -1],
                         [-1, -1, -1, -1, -1]
                         ]) / 16


lena_filtre_hp_3 = convolution(image, pass_haut_filter(3))
lena_filtre_hp_5 = convolution(image, pass_haut_filter(5))
filtered_img_hp_conv = convolve2d(image, pass_haut_filter(3), mode='same')

# Afficher les images résultantes
fig, axs = plt.subplots(1, 4, figsize=(10, 5))

axs[0].imshow(image, cmap='gray', vmin=0, vmax=255)
axs[0].set_title('Image originale')

axs[1].imshow(lena_filtre_hp_3, cmap='gray', vmin=0, vmax=255)
axs[1].set_title('Filtre passe-haut 3x3')

axs[2].imshow(lena_filtre_hp_5, cmap='gray', vmin=0, vmax=255)
axs[2].set_title('Filtre passe-haut 5x5')

axs[3].imshow(filtered_img_hp_conv, cmap='gray', vmin=0, vmax=255)
axs[3].set_title('Image filtrée passe-haut convolve2d')

for ax in axs:
    ax.axis('off')

plt.show()


# fig, axs = plt.subplots(2, 4, figsize=(10, 5))

# axs[0][0].imshow(image, cmap='gray', vmin=0, vmax=255)
# axs[0][0].set_title('Image originale')
# axs[0][1].imshow(filtered_img_pb_3, cmap='gray', vmin=0, vmax=255)
# axs[0][1].set_title('Filtre passe-bas 3x3')
# axs[0][2].imshow(filtered_img_pb_5, cmap='gray', vmin=0, vmax=255)
# axs[0][2].set_title('Filtre passe-bas 5x5')
# axs[0][3].imshow(filtered_img_pb_conv, cmap='gray', vmin=0, vmax=255)
# axs[0][3].set_title('Image filtrée passe-bas convolve2d')
# axs[1][0].imshow(image, cmap='gray', vmin=0, vmax=255)
# axs[1][0].set_title('Image originale')
# axs[1][1].imshow(lena_filtre_hp_3, cmap='gray', vmin=0, vmax=255)
# axs[1][1].set_title('Filtre passe-haut 3x3')
# axs[1][2].imshow(lena_filtre_hp_5, cmap='gray', vmin=0, vmax=255)
# axs[1][2].set_title('Filtre passe-haut 5x5')
# axs[1][3].imshow(filtered_img_hp_conv, cmap='gray', vmin=0, vmax=255)
# axs[1][3].set_title('Image filtrée passe-haut convolve2d')

# for axss in axs:
#     for ax in axss:
#         ax.axis('off')

# plt.show()

# # Les filtres passe-bas ont pour effet de supprimer les hautes fréquences
# # de l'image et de ne laisser que les basses fréquences.
# # Cela a pour effet de flouter l'image. Les filtres passe-haut ont pour
# # effet de supprimer les basses fréquences de l'image et de ne laisser
# # que les hautes fréquences. Cela a pour effet de renforcer
# # les contours et les détails de l'image.

# # III. Représentation fréquentielle

def fourierImage(image):
    return np.log10(np.abs(np.fft.fftshift(np.fft.fft2(image))))

# plt.imshow(fourierImage(image), cmap='gray', vmin=0, vmax=255)
# plt.colorbar()
# plt.show()


# # Appliquer la convolution avec le filtre passe-bas 5x5
# filtered_img = convolve2d(image, passe_bas_binomial(5))

# # Calculer la représentation fréquentielle de l'image d'origine et de l'image filtrée
# fft_img = np.fft.fft2(image)
# fft_filtered_img = np.fft.fft2(filtered_img)

# # Afficher les deux images en représentation fréquentielle
# fig, axs = plt.subplots(1, 2, figsize=(10, 5))

# axs[0].imshow(np.log(np.abs(np.fft.fftshift(fft_img))), cmap='gray', vmin=0, vmax=255)
# axs[0].set_title('Représentation fréquentielle de l\'image d\'origine')
# axs[1].imshow(np.log(np.abs(np.fft.fftshift(fft_filtered_img))), cmap='gray', vmin=0, vmax=255)
# axs[1].set_title(
#     'Représentation fréquentielle de l\'image filtrée avec un passe-bas 5x5')

# plt.show()


def eqm(image1, image2):
    return np.mean((image1 - image2)**2)

# Les basses fréquences ont un rôle prépondérant sur l'erreur quadratique moyenne et donc sur le contenu de l'image.
# En effet, les basses fréquences représentent les variations lentes dans l'image,
# tandis que les hautes fréquences représentent les variations rapides.
# Les variations lentes ont donc plus d'impact sur l'ensemble de l'image que les variations rapides,
# qui peuvent être considérées comme du bruit ou des détails fins.
