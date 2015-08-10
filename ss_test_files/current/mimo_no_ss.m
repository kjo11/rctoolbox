addpath('../../toolbox');
s = tf('s');
per = conper('LS',0.3,5/s);
G = [2/(s+0.4); 2/(s+0.1)];
opts = condesopt('gbands','off');

%% PID, default C
phi1 = conphi('pid',0.1,'s',[],'ss');
phi2 = conphi('pid',0.1,'s');

K1 = condes(G,phi1,per,opts);
K2 = condes(G,phi2,per,opts);

figure; bode(K1,K2);

%% PID, given C
phi1 = conphi('pid',0.1,'s',[],'ss',{'c',[7 1]});
phi2 = conphi('pid',0.1,'s');

K1 = condes(G,phi1,per,opts);
K2 = condes(G,phi2,per,opts);

figure; bode(K1,K2);

%% PID, given B
phi1 = conphi('pid',0.1,'s',[],'ss',{'b',[1 1]'});
phi2 = conphi('pid',0.1,'s');

K1 = condes(G,phi1,per,opts);
K2 = condes(G,phi2,per,opts);

figure; bode(K1,K2);

%% Laguerre, default C
phi1 = conphi('Laguerre',[0.1 5],'s',[],'ss');
phi2 = conphi('Laguerre',[0.1 5],'s');

K1 = condes(G,phi1,per,opts);
K2 = condes(G,phi2,per,opts);

figure; bode(K1,K2);

%% Laguerre, given C
phi1 = conphi('Laguerre',[0.1 5],'s',[],'ss',{'c',[1 2 3 4 5]});
phi2 = conphi('Laguerre',[0.1 5],'s');

K1 = condes(G,phi1,per,opts);
K2 = condes(G,phi2,per,opts);

figure; bode(K1,K2);

%% Laguerre, given B
phi1 = conphi('Laguerre',[0.1 5],'s',[],'ss',{'b',[1 2 3 4 5]'});
phi2 = conphi('Laguerre',[0.1 5],'s');

K1 = condes(G,phi1,per,opts);
K2 = condes(G,phi2,per,opts);

figure; bode(K1,K2);



