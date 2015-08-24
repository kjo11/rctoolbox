addpath('../../toolbox');
s = tf('s');

%%
disp('PID, tau=0, continuous, default C')
phi = conphi('pd',[],'s',[],'ss');
phi2 = conphi('pd',0.12,'s',[],'ss');

per = conper('LS',0.3,5/s);
G = 2/(s+0.5);

condes(G,phi,per);
