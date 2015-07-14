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
per=conper('LS',0.1,5/s); 

K=condes(G,phi,per);

%% Test condes with G in UD
phiPI = conphi('UD',[1/(s-1); 1/(s*(s-1))]);
K2=condes(G,phiPI,per);

figure; bode(K,K2)