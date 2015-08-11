addpath('../../toolbox')
addpath(genpath('../../../matlab_tools'))

s = tf('s');

G = 1/(1+s);
tau = 2;
P = G*exp(-tau*s);
H = G*(1-exp(-tau*s));
Ld = 1/s;
W{1} = tf(0.04);

phi = conphi('pid',[],'s',[],'sp',H);
per = conper('Hinf',W,Ld);
opts = condesopt('yalmip','on','gamma',[0.2 2 0.01],'lambda',[1 0 0 0],'ntheta',[]);

K = condes(P,phi,per,opts);