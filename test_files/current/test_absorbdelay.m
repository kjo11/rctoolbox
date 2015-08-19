s = tf('s');
Ts = 0.5;

Gc = exp(-s)/((s+1)*s);
Gd = c2d(Gc,Ts)
absorbDelay(Gd)

pole(Gd)
pole(absorbDelay(Gd))