addpath('../toolbox');
addpath('../orig_toolbox');

%% SISO
load flex_trans.mat

wc = 0.74;
Mm = 0.7;
Ku = 6.5;

z = tf('z');
s = tf('s');
Ts = 0.04;
n = 7;

F = z/(z-1);
phi = conphi('Laguerre',[Ts 0 n],'z',F);

W{1} = wc/(s+wc);
Ld = wc/s;
per=conper('Hinf',W,Ld);

nq = 8; % Number of vertices for approximating uncertainty circles
lambda = [1 0 0 0];
g_min = 0.001; g_max = 3; tol=0.00001; % gamma bounds
opt1 = condesopt('gamma',[g_min, g_max, tol], 'lambda', lambda,'nq',nq,...
    'Algorithm','active-set');
g_min = 0.001; g_max = 5; tol=0.00001; % gamma bounds
opt2 = condesopt('gamma',[g_min, g_max, tol], 'lambda', lambda,'nq',nq,...
    'Algorithm','active-set');



K1 = condes(G,phi,per,opt1);
K2 = condes(G,phi,per,opt2);

Korig1 = condes_orig(G,phi,per,opt1);
Korig2 = condes_orig(G,phi,per,opt2);

figure; bode(K1*G{1},K2*G{1},Korig1*G{1},Korig2*G{1},Ld)
legend('K1','K2','Korig1','Korig2')

%% MIMO
clear G
G = [exp(-5*s)/(s^2+14*s+7.5), exp(-s)*2/(20*s+1)];

phi = conphi('Laguerre',[1 n],'s',1/s);

W{1} = wc/(s+wc)*5;
Ld = wc/s;
per=conper('Hinf',W,Ld);


K1 = condes(G,phi,per,opt1);
K2 = condes(G,phi,per,opt2);

Korig1 = condes_orig(G,phi,per,opt1);
Korig2 = condes_orig(G,phi,per,opt2);


figure; bode(G*K1,G*K2,G*Korig1,G*Korig2,Ld)