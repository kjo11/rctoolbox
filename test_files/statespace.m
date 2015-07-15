addpath('../toolbox')

%% Test conphi
Aeigs = -[1 2 3 4];
C = [1 0 0 0; 0 1 0 0];
phi = conphi('SS',{Aeigs,C},'s');

%% Test condes with G in ss
s = tf('s');
G = ss(1/(s^2+14*s+7.5));
Aeigs = [-1 0];

phi=conphi('SS',Aeigs,'s'); 
Ld = 5/s;
per=conper('LS',0.1,Ld); 

K=condes(G,phi,per);

%% Test condes with G in UD
phiUD = conphi('UD',[1/(s-1); 1/(s*(s-1))]);
K2=condes(G,phiUD,per);

figure; bode(K,K2)

%% MIMO G with PI
phiPI = conphi('PI');
G = [exp(-5*s)/(s^2+14*s+7.5), exp(-s)*2/(20*s+1)];
Kmimo = condes(G,phi,per);


%% MIMO conphi ss
C = [1 0 0; 1 0 0];
Aeigs = [0 -0.5 -0.5];
% phiMIMO = conphi('SS',{Aeigs,C},'s');
phiMIMO = conphi('ss',Aeigs,'s');

%% MIMO condes
Gtf = [1/(s^2+14*s+7.5), tf(0,1); tf(0,1), 2/(20*s+1)];
Gtf = [Gtf; Gtf];
% Gtf = [1/(s+1), 1/(0.9*s+1)];
G = ss(Gtf);

phiLag = conphi('Laguerre',[0.5 3],'s');
opts = condesopt('Gbands','off');

Kss = condes(G,phiMIMO,per,opts);




