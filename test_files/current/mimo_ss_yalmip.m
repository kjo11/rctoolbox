addpath('../../toolbox');
addpath(genpath('../../../matlab_tools'));
s = tf('s');
per = conper('LS',0.3,5/s);

W{1} = 1/(s+1);
per = conper('hinf',W,1/s);

per = conper('GPhC',[2 45 10],1/s);

G = [2/(s+0.4), 0.001; 2/(s+1), 0.05/(s+2)];
G = [2/(s+1); 0.05/(s+2)];
opts = condesopt('gbands','off','yalmip','on','lambda',[1 0 0 0],'gamma',[0.01 2 0.001]);
opts2 = condesopt('gbands','off','yalmip','off','lambda',[1 0 0 0],'gamma',[0.01 2 0.001]);

%% PID, default C
phi1 = conphi('pid',0.1,'s',[],'ss');
phi2 = conphi('pid',0.1,'s');

K1 = condes(G,phi1,per,opts);
K2 = condes(G,phi1,per,opts2);

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



