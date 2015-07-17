
clear all


% Single model, SISO, continuous, PID, 'GPhC', Quadprog

s=tf('s');
G=exp(-5*s)/(s*(s+1)^3);

phi=conphi('PID');
per=conper('GPhC',[2,60,.09],.1/s^2);


K=condes(G,phi,per)

% Optimization terminated.
% 
% K =
%  
%   42.41 s^2 + 8.05 s + 0.184
%   --------------------------
%         s^2 + 83.33 s
%  
% Continuous-time transfer function.

