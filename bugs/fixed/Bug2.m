% Bug 2: Unstable controller for negative plant models for PID with GPhC 
% performance and no crossover frequency given. Stable but non-optimal 
% controller if crossover frequency given.

addpath('../../toolbox');

%% Test negative plant model with loopshaping -- this works
% controllers computed using the negative and positive model are identical

Ts = 0.01; % sampling time (s)
Gc = tf(0.1034,[0.08791,1]); % continuous time model
% Gc = tf(100,[0.1,1]);
Gd = c2d(Gc,Ts); % discrete time model
% Gd = Gd*z/(z-1);
Mm_min = 0.5; % modulus margin
Ku = db2mag(20); % limit of u gain in high frequencies
wh = 20*2*pi; % defines high frequencies ^^
%%
s = tf('s');
z = tf('z');
wc = 10; % crossover frequency
Ld = wc/s; % desired OL transfer function

phi_PI = conphi('PI',Ts,'z^-1');
per_ls = conper('LS', [Mm_min,Ku,wh], Ld);

K_ls_pos = condes(Gd,phi_PI,per_ls);
K_ls_neg = -condes(-Gd,phi_PI,per_ls);

figure; hold on
step(feedback(K_ls_neg*Gd,1));
step(feedback(K_ls_pos*Gd,1));

%% Test negative plant model with gain/phase/crossover
% controllers computed using the negative and positive plant model are
% different but both are stable

g_m = 4; % minimum desired gain margin
phi_m = 65; % minimum desired phase margin

per_gpc = conper('GPhC', [g_m, phi_m, wc]);

K_gpc_pos = condes(Gd,phi_PI,per_gpc);
K_gpc_neg = -condes(-Gd,phi_PI,per_gpc);

figure; hold on
step(feedback(K_gpc_pos*Gd,1),'-b');
step(feedback(K_gpc_neg*Gd,1),'-r');
legend('pos','neg')

%% Test negative plant model with gain/phase
% No crossover frequency given so algorithm tries to maximize controller
% gain in low frequencies
% controller computed using the positive plant model is stable but using
% the negative plant model the system becomes unstable

per_gp = conper('GPhC', [g_m, phi_m]);

K_gp_pos = condes(Gd,phi_PI,per_gp);
K_gp_neg = -condes(-Gd,phi_PI,per_gp);

figure; hold on
step(feedback(K_gp_neg*Gd,1));
step(feedback(K_gp_pos*Gd,1));

%% Test with Laguerre and gain/phase
n = 3;
F = z/(z-1);
phi_La = conphi('Laguerre',[Ts 0 n],'z^-1');

K_la_pos = condes(Gd,phi_La,per_gpc);
K_la_neg = -condes(-Gd,phi_La,per_gpc);

figure; hold on
step(feedback(K_la_pos*Gd,1),'-b');
step(feedback(K_la_neg*Gd,1),'-r');
legend('pos','neg')

%% Test with PD and gain/phase
phi_PD = conphi('PD',Ts,'z^-1');

Gd2 = Gd*z/(z-1);

K_pd_pos = condes(Gd,phi_PD,per_gp);
K_pd_neg = -condes(-Gd,phi_PD,per_gp);

figure; hold on
step(feedback(K_pd_neg*Gd,1));
step(feedback(K_pd_pos*Gd,1));


