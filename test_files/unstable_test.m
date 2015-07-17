s=tf('s');

G = 4/(10*s-1);

phi = conphi('PID');
per = conper('LS',0.3,5/s*(s+1)/(s-1));

K = condes(G,phi,per);
figure; step(feedback(K*G,1))