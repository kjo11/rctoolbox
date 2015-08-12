addpath('../toolbox')
addpath(genpath('../../matlab_tools'))

s = tf('s');

G = 1/(1+s);
tau = 2;
P = G*exp(-tau*s);
H = G*(1-exp(-tau*s));
Ld = 1/s;
W{1} = tf(0.4);

phi = conphi('pid',[],'s',[],'sp',H);
per = conper('Hinf',W,Ld);
opts = condesopt('yalmip','on','gamma',[0.2 1 0.1],'lambda',[1 0 0 0],'ntheta',[]);

[C,sol] = condes(P,phi,per,opts);


%%
K = feedback(C,H);
S = feedback(1,K*P);

figure; bode(W{1}*S,tf(sol.gamma))