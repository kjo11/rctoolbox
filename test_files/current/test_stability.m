s = tf('s');

G = exp(-s)/(s+1)^3;
Ld = 1/(s+1);

phi=conphi('pid',0.2,'s');
per=conper('LS',0.3,Ld);

K=condes(G,phi,per);