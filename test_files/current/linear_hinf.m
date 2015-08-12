addpath('../../toolbox')
addpath(genpath('../../../matlab_tools'))

s = tf('s');

G = 1/(1+s);
tau = 2;
P = G*exp(-tau*s);
H = G*(1-exp(-tau*s));
Ld = 1/s;
W{1} = tf(0.4);

phi = conphi('pid',[],'s',[],'sp',H);
per = conper('Hinf',W,Ld);
opts = condesopt('yalmip','off','gamma',[0.2 2 0.01],'lambda',[0 0 0 0],'ntheta',5);

[C,sol] = condes(P,phi,per,opts);

%%
% K = feedback(C,H);
% S = feedback(1,K*P);
% T = 1-S;
% U = K*S;
% V = P*S;
% 
% figure; bode(W{1}*S,tf(sol.gamma))
w = logspace(-3,3);
p1 = squeeze(freqresp(W{1}*(tf(1)+C*H),w));
p1 = abs(p1) .* abs(squeeze(freqresp(1+Ld,w)));
p2 = squeeze(freqresp((1+conj(Ld))*(1+C*(H+P)),w));
figure; semilogx(w,p1); hold on
semilogx(w,real(p2),'-g')