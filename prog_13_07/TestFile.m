%%
addpath('../toolbox/');
addpath('../orig_toolbox/');

%%
s=tf('s');

G{1}=exp(-3*s)*4/(10*s+1); 
% G{1} = 4/(10*s-1);
G{2}=exp(-5*s)/(s^2+14*s+7.5); 
G{3}=exp(-s)*2/(20*s+1);

Ld=1/(30*s);

%% Test 1
[~,~, wG]=bode(G{1});
Ldfrd=frd(Ld,wG);

phi=conphi('PI'); 

per=cell(1,2);
per{1,1}=conper('LS',0.5,Ldfrd ); 
per{1,2}=conper('LS',0.5,Ld); 
per{1,3}=conper('LS',0.5,Ld); 



K=condes(G,phi,per);
figure; step(feedback(K*G{1},1))


%% Test 2
Ldfrd2=frd(Ld,logspace(1,2,50));

per=cell(1,2);
per{1,1}=conper('LS',0.5,Ldfrd); 
per{1,2}=conper('LS',0.5,Ldfrd2); 
per{1,3}=conper('LS',0.5,Ldfrd2); 

K=condes(G,phi,per)
figure; step(feedback(K*G{1},1))


%% Test 3

per=conper('LS',0.5,Ld); 

F=cell(1,2);
F{1}=frd(3/s,wG);
F{2}=frd(3/s,logspace(1,2,50));
F{3}=frd(3/s,wG);

opt=condesopt('F',F);

K=condes(G,phi,per,opt)
figure; step(feedback(K*G{1},1))


%% Test 4
per=conper('LS',0.5,Ldfrd2); 

F2=frd(3/s,wG);

opt=condesopt('F',F2);

K=condes(frd(G{1},wG),phi,per,opt)
figure; step(feedback(K*G{1},1))

%% Error with negative plant models
G1 = 0.1/(0.1*s+1);
Gc = c2d(G1,0.01);

g_m = 2;
phi_m = 45;
wc = 1;
Ts = 0.01;

phi = conphi('PI',Ts,'z');


per_gpc = conper('GPhC', [g_m, phi_m, wc]);
per_gp = conper('GPhC', [g_m, phi_m]); 

K_orig{1} = condes_orig(Gc,phi,per_gpc);
K_orig{2} = -condes_orig(-Gc,phi,per_gpc);
K_orig{3} = condes_orig(Gc,phi,per_gp);
K_orig{4} = -condes_orig(-Gc,phi,per_gp);

Kc{1} = condes(Gc,phi,per_gpc);
Kc{2} = -condes(-Gc,phi,per_gpc);
Kc{3} = condes(Gc,phi,per_gp);
Kc{4} = -condes(-Gc,phi,per_gp);

figure; hold on
step(feedback(K_orig{1}*Gc,1));
step(feedback(K_orig{2}*Gc,1));
title('Original condes, GPhC');
legend('Pos','Neg')
figure; hold on
step(feedback(K_orig{3}*Gc,1));
step(feedback(K_orig{4}*Gc,1));
title('Original condes, GPh');
legend('Pos','Neg')
figure; hold on
step(feedback(Kc{1}*Gc,1));
step(feedback(Kc{2}*Gc,1));
step(feedback(Kc{3}*Gc,1));
step(feedback(Kc{4}*Gc,1));
title('Original condes');
legend('Pos GPhC','Neg GPhC','Pos GPh','Neg GPh')

%% Reduced order of Laguerre basis controllers

load flex_trans.mat
s = tf('s');
z = tf('z');

Ld = 1/(5*s);

n = 7;
Mm = 0.45;
Ku = 1;
wc = 1;

F = z/(z-1);

% Laguerre - 0
phi = conphi('Laguerre',[G{1}.Ts, 0, n],'z',F);
per = conper('LS',[Mm,Ku,wc],Ld);

K = condes(G,phi,per);
tf(K)
K_orig = condes_orig(G,phi,per);
tf(K_orig)

% Laguerre - 1
phi = conphi('Laguerre',[G{1}.Ts, 0.9, n],'z',F);
per = conper('LS',[Mm,Ku,wc],Ld);

K = condes(G,phi,per);
tf(K)
K_orig = condes_orig(G,phi,per);
tf(K_orig)

% Laguerre - 2
phi = conphi('Laguerre',[G{1}.Ts, 0.6, n],'z',F);
per = conper('LS',[Mm,Ku,wc],Ld);

K = condes(G,phi,per);
tf(K)
K_orig = condes_orig(G,phi,per);
tf(K_orig)

% Generalized
phi=conphi('Generalized',[0.1 0.2 0.3 0.4 0 0.6 0 0 0 0 0 0 0 ],'z',F);
per = conper('LS',[Mm,Ku,wc],Ld);

K = condes(G,phi,per);
tf(K)
K_orig = condes_orig(G,phi,per);
tf(K_orig)

%% Stability test
s=tf('s');

G = 4/(10*s-1);
Ld_stab = 5/s*(s+1)/(s-1);
Ld_unstab = 5/s;

phi = conphi('PID');
per_stab = conper('LS',0.3,Ld_stab);
per_unstab = conper('LS',0.3,Ld_unstab);

K_stab = condes(G,phi,per_stab);
K_unstab = condes(G,phi,per_unstab);
figure; nyquist(K_stab*G,K_unstab*G)
