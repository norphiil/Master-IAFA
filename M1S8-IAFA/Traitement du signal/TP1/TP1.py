import matplotlib.pyplot as plt
import numpy as np
import scipy.io.wavfile as wav

# # I. Manipulation de fichiers numériques

# # 1. Signal audio

# # Charger le fichier audio
# fs, signal = wav.read('assets/diner.wav')

# print("La fréquence d'échantillonnage est de", fs, "Hz.")

# # Convertir les données d'entiers à réels flottants (quantification est sur 16 bits)
# signal = signal / 32767.0  # 32767 est la valeur maximale d'un entier 16 bits

# # Calculer la durée du fichier
# duree = len(signal) / fs
# print("Durée du fichier :", duree, "secondes")

# # Créer l'axe des abscisses en secondes
# temps = np.arange(0, len(signal)) / fs

# # Afficher le signal graphiquement
# plt.plot(temps, signal)
# plt.xlabel("Temps (s)")
# plt.ylabel("Amplitude")
# plt.title("Signal audio")
# plt.show()

# # Afficher les 10 premières valeurs du signal qui sont différentes de 0
# indices = np.nonzero(signal)[0][:10]
# print("Les 10 premières valeurs du signal qui sont différentes de 0 sont :",
#       signal[indices])

# # 2. Image

# # Charger l'image
# img = plt.imread('assets/photo.jpg')

# # Afficher la taille et le contenu de l'image
# print("Taille de l'image :", img.shape)
# print("Contenu de l'image :", img)

# # Afficher l'image
# plt.imshow(img)
# plt.show()

# # Afficher les intensités en RGB du premier pixel de l'image
# premier_pixel = img[0, 0]
# print("Intensités RGB du premier pixel :", premier_pixel)

# # II. Quantification, échantillonnage


def sous_quantification_audio(n_bits, signal, fs):
    # Calculer le facteur de quantification
    q = 2 ** (16 - n_bits)

    # Sous-quantifier le signal
    signal_q = np.round(signal / q) * q

    # Enregistrer le signal sous-quantifié dans un fichier audio
    filename = "out/signal_sous_quantifie_" + str(n_bits) + "_bits.wav"
    wav.write(filename, fs, signal_q.astype(np.int16))

    return signal_q


def sous_echantillonnage_audio(fs, signal, n: int) -> np.ndarray:
    # Sous-échantillonner le signal
    signal_s = signal[::n]

    # Enregistrer le signal sous-échantillonné dans un fichier audio
    filename = "out/signal_sous_echantillonne_x" + str(n) + ".wav"
    wav.write(filename, fs // n, signal_s.astype(np.int16))

    return signal_s


# # Charger le signal audio
# fs, signal = wav.read("assets/diner.wav")

# # Sous-quantifier le signal avec différentes quantifications
# signal_12_bits = sous_quantification_audio(12, signal, fs)
# signal_8_bits = sous_quantification_audio(8, signal, fs)
# signal_4_bits = sous_quantification_audio(4, signal, fs)
# signal_2_bits = sous_quantification_audio(2, signal, fs)

# # En écoutant les différents fichiers audio résultants,
# # on peut remarquer que la qualité sonore diminue à mesure
# # que le nombre de bits utilisés pour la quantification diminue.
# # Le signal sous-quantifié à 12 bits est très proche du signal original,
# # tandis que le signal sous-quantifié à 2 bits présente des artefacts
# # audibles et une perte significative de qualité sonore.

# signal = sous_echantillonnage_audio(fs, signal, 2)
# signal = sous_echantillonnage_audio(fs, signal, 4)
# signal = sous_echantillonnage_audio(fs, signal, 8)

# # En écoutant les différents fichiers audio résultants,
# # on peut remarquer que la piste audio accélère et que
# # le temps de l'audio diminue. Pour le facteur de sous-échantillonnage x2,
# # il n'y a pas de changement majeur. En revanche, pour le facteur de x4,
# # le temps de l'audio est divisé par deux, et pour le facteur de x8,
# # le temps de l'audio est d'environ une seconde pour 10 secondes
# # dans le fichier original. De plus, la qualité sonore diminue et
# # le son devient plus aigu et plus aiguisé, ce qui peut entraîner une distorsion.

def sous_quantification_image(image, n):
    mask = (2 ** n - 1) << (8 - n)
    r, g, b = np.rollaxis(image, axis=-1)
    r = np.bitwise_and(r, mask).astype(np.uint8)
    g = np.bitwise_and(g, mask).astype(np.uint8)
    b = np.bitwise_and(b, mask).astype(np.uint8)
    image_quant = np.dstack((r, g, b))
    return image_quant


# # Charge l'image
# img = plt.imread('assets/photo.jpg')

# # Sous-quantifie l'image avec 2 bits
# img_quant_2 = sous_quantification_image(img, 2)

# # Sous-quantifie l'image avec 3 bits
# img_quant_3 = sous_quantification_image(img, 3)

# fig, (ax1, ax2, ax3) = plt.subplots(1, 3, figsize=(15, 5))
# ax1.imshow(img)
# ax1.set_title('Image')
# ax2.imshow(img_quant_2)
# ax2.set_title('Sous-quantifie l\'image avec 2 bits')
# ax3.imshow(img_quant_3)
# ax3.set_title('Sous-quantifie l\'image avec 3 bits')
# plt.show()

# # En testant cette fonction avec 2 bits et 3 bits,
# # nous remarquons que plus le nombre de bits de poids
# # fort gardé est faible, plus l'image sous-quantifiée
# # est bruitée et de moins bonne qualité.
# # Cela est dû à la perte d'information lors de la quantification,
# # où des détails de l'image sont perdus.
