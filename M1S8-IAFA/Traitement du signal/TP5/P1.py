# I. Rehaussement par Laplacien

import numpy as np
import matplotlib.pyplot as plt
from scipy import signal

laplacian = np.array([[0, 1, 0], [1, -4, 1], [0, 1, 0]])

image = plt.imread('images/peppers.png')

filtered_image = np.zeros(image.shape)
for i in range(image.shape[2]):
    filtered_image[:, :, i] = signal.convolve2d(
        image[:, :, i], laplacian, mode='same')

enhanced_image = np.clip(image - filtered_image, 0, 255)

fig, (ax1, ax2, ax3) = plt.subplots(1, 3, figsize=(15, 5))
ax1.imshow(image)
ax1.set_title('Image originale')
ax2.imshow(filtered_image)
ax2.set_title('Image filtrée avec un masque Laplacien')
ax3.imshow(enhanced_image)
ax3.set_title('Image rehaussée avec égalisation d\'histogramme')
plt.show()
