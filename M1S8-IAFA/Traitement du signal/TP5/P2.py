# # II. Manipulation des composantes RGB d'une image

import numpy as np
import matplotlib.pyplot as plt
from PIL import Image

image = np.array(Image.open('images/2cv.jpg'))


def getImageDim(image, dim):
    img_color = np.zeros(image.shape, dtype=np.uint8)
    img_color[:, :, dim] = image[:, :, dim]
    return img_color

# # 1. Affichage des composantes de l'image de la voiture : 2cv.jpg

# # En observant les trois images, nous pouvons remarquer que les pixels correspondant à la
# # carrosserie de la voiture ont des intensités différentes dans les trois composantes de couleur.
# # Cela indique que la couleur de la carrosserie est une combinaison de rouge, de vert et de bleu
# # différents qui donnent la couleur bleu ciel de la carrosserie. Nous pouvons donc remarquer que
# # l'intensité du vert et du bleu est plus élevée, tandis que le rouge donne une carrosserie noire
# # car le bleu ciel est une combinaison de vert et de bleu seulement.


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


# fig, ((ax1, ax2, ax3), (ax4, ax5, ax6)) = plt.subplots(2, 3, figsize=(15, 5))
# ax1.imshow(image)
# ax1.set_title('Image originale')
# ax2.imshow(getImageDim(image, 0))
# ax2.set_title('Image Rouge')
# ax3.imshow(getImageDim(image, 1))
# ax3.set_title('Image Vert')
# ax4.imshow(getImageDim(image, 2))
# ax4.set_title('Image Bleu')
# ax5.imshow(getFiltredImage(image=image, seuil=[110], dim=[2], sup=[True]))
# ax5.set_title('Image filtrée')
# plt.show()


# 2. Filtrage en fonction des composantes


def showRangeFiltredImage(image: np.ndarray, nb: int, row: int, step: float, start: int = 0, dim: int = 2, sup: bool = True) -> None:
    fig, (row1, row2) = plt.subplots(
        row, int(nb / row), figsize=(15, 5))
    for i in range(0, 10):
        if i < nb / row:
            ax = row1[(i % int(nb / row))]
        else:
            ax = row2[(i % int(nb / row))]
        ax.imshow(getFiltredImage(
            image=image, seuil=[start + i * step], dim=[dim], sup=[sup]))
        ax.set_title('Image ' + str(start + i * step))
    plt.show()


# showRangeFiltredImage(image, nb=10, row=2, step=20)
# showRangeFiltredImage(image, nb=10, row=2, step=2, start=120)

# # La valeur de la variable seuil sur la composante bleue qui permet
# # d'obtenir la carrosserie complète de la voiture tout en éliminant un maximum
# # des autres pixels de l'image est de 132.

# # Après avoir filtré l'image avec ce seuil, les principales zones qui ont été retenues
# # sont les zones de l'image qui ont une forte intensité en bleu, principalement la
# # carrosserie de la voiture et le ciel. De plus certaines zones blanches ont été
# # retenues, ce qui est normal car le blanc contient toutes les couleurs et donc
# # une forte intensité en bleu.

# showRangeFiltredImage(image, nb=10, row=2, step=20, start=0, dim=0, sup=False)
# showRangeFiltredImage(image, nb=10, row=2, step=2, start=100, dim=0, sup=False)

# # La valeur de la variable seuil sur la composante rouge qui permet
# # d'obtenir la carrosserie complète de la voiture tout en éliminant un maximum
# # des autres pixels de l'image est de 110.

# # Le seuil de 110 permet de retenir les zones de l'image qui ont une faible intensité
# # de rouge, ce qui correspond à la carrosserie de la voiture. cela permet d'enlever le ciel
# # qui est moins blue et qui contient plus de rouge.

# fig, (ax1) = plt.subplots(1, 1, figsize=(15, 5))
# ax1.imshow(getFiltredImage(image=image, seuil=[
#            110, 132], dim=[0, 2], sup=[False, True]))
# ax1.set_title('Image')
# plt.show()


def setCarToGreen(image: np.ndarray) -> np.ndarray:
    green_car = image.copy()
    green_carFiltre = getFiltredImage(image=image, seuil=[
        110, 130], dim=[0, 2], sup=[False, True])
    mask = np.any(green_carFiltre != [0, 0, 0], axis=-1)
    green_car[mask, 1], green_car[mask,
                                  2] = green_car[mask, 2], green_car[mask, 1]
    return green_car


# fig, (ax1) = plt.subplots(1, 1, figsize=(15, 5))
# ax1.imshow(setCarToGreen(image))
# ax1.set_title('Image')
# plt.show()

# # III. Conversion d'image

# # 1. Image en niveaux de gris et image binaire


def setImageToGrey(image: np.ndarray) -> np.ndarray:
    return 0.2126 * image[:, :, 0] + 0.7152 * \
        image[:, :, 1] + 0.0722 * image[:, :, 2]


def binarizeImage(image: np.ndarray, seuil: float) -> np.ndarray:
    return (setImageToGrey(image=image) > seuil) * 255


# fig, (ax1, ax2, ax3) = plt.subplots(1, 3, figsize=(15, 5))
# ax1.imshow(image)
# ax1.set_title('Image')
# ax2.imshow(setImageToGrey(image), cmap='gray')
# ax2.set_title('Image Grey')
# ax3.imshow(binarizeImage(image, 125), cmap='gray')
# ax3.set_title('Image Binarize')
# plt.show()

# 2. Histogramme

def getHistogram(image: np.ndarray) -> np.ndarray:
    return np.histogram(setImageToGrey(image), bins=256, range=(0, 256))


# # Afficher l'histogramme
# hist, bins = getHistogram(image)
# plt.bar(bins[:-1], hist, width=1)
# plt.title('Histogramme de l\'image en niveaux de gris')
# plt.xlabel('Intensité')
# plt.ylabel('Nombre de pixels')
# plt.show()

# # Oui il est possible de binariser l'image en niveaux de
# # gris de manière plus intelligente avec l'aide de l'histogramme,
# # en calculant un seuil de binarisation pour chaque pixel de l'image
# # en fonction des valeurs des pixels voisins.

def binarizeImageWithHistogram(image: np.ndarray, k: float = 0.2, w: int = 100) -> np.ndarray:
    grey_image = setImageToGrey(image)
    H, W = grey_image.shape

    img_bin = np.zeros((H, W), dtype=np.uint8)

    for i in range(H):
        for j in range(W):
            i_min = max(i - w // 2, 0)
            i_max = min(i + w // 2, H)
            j_min = max(j - w // 2, 0)
            j_max = min(j + w // 2, W)
            window = grey_image[i_min:i_max, j_min:j_max]
            mean = np.mean(window)
            std = np.std(window)

            threshold = mean + k * std

            if grey_image[i, j] >= threshold:
                img_bin[i, j] = 255
    return img_bin

# fig, (ax1) = plt.subplots(1, 1, figsize=(15, 5))
# ax1.imshow(binarizeImageWithHistogram(image), cmap='gray')
# ax1.set_title('Image')
# plt.show()
