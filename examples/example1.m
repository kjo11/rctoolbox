

% Single model, SISO, continuous, PID, 'GPhC', Linprog

s=tf('s');
G=exp(-s)/(s+1)^3;

phi=conphi('PID');
per=conper('GPhC',[2,60,.08]);

K=condes(G,phi,per)


% Optimization terminated.
% 
% K =
%  
%   174 s^2 - 16.5 s + 7.769
%   ------------------------
%        s^2 + 83.33 s
%  
% Continuous-time transfer function.

