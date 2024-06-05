import numpy as np
import matplotlib.pyplot as plt
import scipy.io.wavfile as wav

filename = 'L1.wav'
fs, signal = wav.read(filename)
signal = signal[27800:28823]

# # I. Paramétrisations spectrale et cepstrale

# window_size = len(signal)
# window = np.hamming(window_size)
# signal_windowed = signal * window

# spectrum = np.fft.fft(signal_windowed)
# spectrum = np.abs(spectrum[:window_size // 2])

# log_spectrum = np.log(spectrum)
# cepstrum = np.abs(np.fft.ifft(log_spectrum))

# fig, axs = plt.subplots(3, 1, figsize=(10, 12))

# # Extrait de signal
# axs[0].plot(np.arange(len(signal)) / fs, signal)
# axs[0].set_title('Extrait de signal')
# axs[0].set_xlabel('Temps (s)')
# axs[0].set_ylabel('Amplitude')

# # Spectre
# axs[1].plot(spectrum)
# axs[1].set_title('Spectre')
# axs[1].set_xlabel('Fréquence (Hz)')
# axs[1].set_ylabel('Amplitude (dB)')

# # Cepstre
# axs[2].plot(cepstrum[:window_size // 2])
# axs[2].set_title('Cepstre')
# axs[2].set_xlabel('Fréquence (Hz)')
# axs[2].set_ylabel('Amplitude')

# plt.tight_layout()
# plt.show()

# # II. Extraction de paramètres temporels


def energie(signal, window_size):
    recouvrement = window_size // 2
    nb_fenetre = (len(signal) // recouvrement) - 1
    nrj = np.zeros(nb_fenetre)
    for i in range(nb_fenetre):
        debut_fenetre = i * recouvrement
        nrj[i] = np.sum(signal[debut_fenetre:debut_fenetre +
                        window_size] ** 2) / window_size
    return nrj


def zcr(signal, window_size):
    recouvrement = window_size // 2
    nb_fenetre = (len(signal) // recouvrement) - 1
    zcr = np.zeros(nb_fenetre)
    for i in range(nb_fenetre):
        debut_fenetre = i * recouvrement
        zcr[i] = np.sum(np.abs(np.sign(signal[debut_fenetre:debut_fenetre + window_size - 1]
                                       ) - np.sign(signal[debut_fenetre + 1:debut_fenetre + window_size]))) / (2 * window_size)
    return zcr


# filename = 'L1.wav'
# fs, signal = wav.read(filename)

# fig, axs = plt.subplots(3, 1, figsize=(10, 12))

# # Extrait de signal
# axs[0].plot(np.arange(len(signal)) / fs, signal)
# axs[0].set_title('Extrait de signal')
# axs[0].set_xlabel('Temps (s)')
# axs[0].set_ylabel('Amplitude')

# # Spectre
# axs[1].plot(energie(signal / 2**15, 2048))
# axs[1].set_title('energie')
# axs[1].set_xlabel('Fréquence (Hz)')
# axs[1].set_ylabel('Amplitude (dB)')

# # Cepstre
# axs[2].plot(zcr(signal, 2048))
# axs[2].set_title('zcr')
# axs[2].set_xlabel('Fréquence (Hz)')
# axs[2].set_ylabel('Amplitude')

# plt.tight_layout()
# plt.show()

# # III. Spectrogramme


filename = 'L1.wav'
fs, signal = wav.read(filename)


def spectro(signal, window_size):
    recouvrement = window_size // 2
    nb_fenetre = (len(signal) // recouvrement) - 1
    spectre_res = np.zeros((window_size // 2, nb_fenetre))
    for i in range(nb_fenetre):
        debut_fenetre = i * recouvrement
        spectre = np.abs(np.fft.fft(
            signal[debut_fenetre:debut_fenetre + window_size]))
        spectre_res[:, i] = np.transpose(spectre[:recouvrement])
    return spectre_res


window_size = 256

spectrogram = spectro(signal, window_size)

plt.imshow(spectrogram, extent=[0, len(signal) // fs, 0, fs],
           aspect="auto", origin="lower")
plt.xlabel("Temps (s)")
plt.ylabel("Fréquence (Hz)")
plt.title("Spectrogramme de L1.wav")
plt.colorbar()
plt.show()

plt.specgram(signal, Fs=fs, window=np.hamming(1024), NFFT=1024)
plt.title("Spectrogramme de L1.wav")
plt.xlabel("Temps (s)")
plt.ylabel("Fréquence (Hz)")
plt.show()
