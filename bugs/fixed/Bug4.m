% Bug 4: Error when giving G with 2 outputs and only 1 input and leaving
% Gbands on

addpath('../../toolbox')

s = tf('s');

G = [1/(s^2+14*s+7.5); 2/(20*s+1)];
phiLag = conphi('PI');
per = conper('LS',0.1,5/s);

K = condes(G,phiLag,per);