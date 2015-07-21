clc
addpath('../../toolbox');
addpath('../../orig_toolbox');

s=tf('s');
G=[exp(-s)/(s+1)^3; exp(-s)/(s+1)^3];

[~,~,w] = bode(G);

Ld = 5/s;

phi=conphi('PID');
per{1}{1}=conper('LS',0.4,frd(Ld,w));
per{1}{2}=conper('LS',0.4,Ld);

K=condes(G,phi,per);

% Optimization terminated.
% 
% K =
%  
%   174 s^2 - 16.5 s + 7.769
%   ------------------------
%        s^2 + 83.33 s
%  
% Continuous-time transfer function.

