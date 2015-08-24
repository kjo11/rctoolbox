% Replicate example for SISO system given in paper

addpath('../toolbox')
addpath(genpath('../../matlab_tools'))

s = tf('s');
G = 1/((5*s+1)*(10*s+1));
P{1} = G*exp(-5*s);
P{2} = G*exp(-4.5*s);
P{3} = G*exp(-5.5*s);

H = G - P{1};

phi = conphi('PID',0.01,'s',[],'SP',H);

W{1} = 2/(30*s+1)^2;
W{2} = (-s^2-2*s)/(s^2+2*s+1);
Ld = 0.1/s;

per = conper('Hinf',W,Ld);

w = linspace(-3,3,100);
gamma = [0.2 0.5 0.01];

opts = condesopt('w',w,'gamma',gamma,'lambda',[1 1 0 0],'yalmip','on');

C = condes(P,phi,per,opts);

% Get gamma = 0.40105 and 
%
% C =
%  
%   1114 s^2 + 305.2 s + 23.14
%   --------------------------
%          s^2 + 100 s
%
%
%
% But in the paper, we have gamma = 0.313 and 
%
%   1230 s^2 + 328 s + 22.01
%   --------------------------
%          s^2 + 100 s
%
%