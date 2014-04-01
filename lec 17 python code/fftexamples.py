#python

import matplotlib.pyplot as plt
import numpy as np

def dbmag(sp,lowmag=-100):
	mag = 20*np.log(sp.real*sp.real + sp.imag*sp.imag);
	idxbad = np.where(mag<lowmag);
	for idx in idxbad:
		mag[idx] = lowmag;
	return mag; 

fs = 44100
maxTime = 0.05;
t = np.linspace(0.0, maxTime, maxTime*fs)
y = np.sin(1000*2*np.pi*t) + np.sin(2250*2*np.pi*t) 

print np.size(y)

sp   = np.fft.fft(y)
freq = np.fft.fftfreq(len(t),d=(1.0/fs))

plt.subplot(2, 1, 1,)
plt.plot(t, y)
plt.subplot(2, 1, 2)
plt.plot(freq, dbmag(sp))
plt.show()