clc
addpath('../toolbox');
addpath('../orig_toolbox');

% Single model, SISO, continuous, PID, 'GPhC', Linprog

s=tf('s');
G=exp(-s)/(s+1)^3;

tau = 0.01;
pid = ss(0.1/s + 2.1*s/(tau*s+1) -0.1991);

Aeigs = eig(pid.a);
C = pid.c;
D = pid.d;

phiSS=conphi('SS',{Aeigs,C,1.36});
phiPID = conphi('PID');

%%
per=conper('GPhC',[1.5,30,.08]);

KSS = condes(G,phiSS,per);
[KPID, sol] = condes(G,phiPID,per);

figure;
step(feedback(KSS*G,1),feedback(KPID*G,1))

% Optimization terminated.
% 
% K =
%  
%   174 s^2 - 16.5 s + 7.769
%   ------------------------
%        s^2 + 83.33 s
%  
% Continuous-time transfer function.

