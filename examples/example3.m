addpath('../toolbox');
addpath('../orig_toolbox/');

clear G per phi

% Three models, SISO, continuous, PID, 'GPhC', Linprog

s=tf('s');
G{1}=exp(-3*s)*4/(10*s+1);
G{2}=exp(-5*s)/(s^2+14*s+7.5);
G{3}=exp(-s)*2/(20*s+1);

phi=conphi('PID',0.05);

per{1}=conper('GPhC',[3,60,.19]);
per{2}=conper('GPhC',[3,60,.007]);
per{3}=conper('GPhC',[3,60,.071]);

freq = logspace(-3,2,400);

options = condesopt ('w',freq);
K=condes(G,phi,per,options);
K2 = condes(G,phi,per,options);

tf(K)
tf(K2)


% Optimization terminated.
% 
% K =
%  
%   11.54 s^2 + 10.35 s + 1.077
%   ---------------------------
%           s^2 + 20 s
%  
% Continuous-time transfer function.
% 
