% addpath('../toolbox')
% addpath('../orig_toolbox/')
% addpath(genpath('../../matlab_tools'))
s=tf('s');
G=[5*exp(-3*s)/(4*s+1) 2.5*exp(-5*s)/(15*s+1); -4*exp(-6*s)/(20*s+1) exp(-4*s)/(5*s+1)];

phi=conphi('pid',[],'s',[],'ss'); 
per=conper('LS',0.5,1/(30*s)); 
opts = condesopt('yalmip','off','gbands','off');

K=condes(G,phi,per,opts)