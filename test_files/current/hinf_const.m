addpath('../../toolbox')
addpath(genpath('../../../matlab_tools'))
s = tf('s');

phi = conphi('lag',[0.2 6],'s',1/s,'tf');
W{1} = 4/s;
per = conper('Hinf',W);

% G{1}{1} = exp(-s)*(s+1)/(s-1)/(s+10);
% G{1}{2} = s/(s+1);
G = (s+1)/(s-1)/(s+10);

opts = condesopt('gamma',[0.01 1.5 0.01],'lambda',[1 0 0 0],'yalmip','on');

K = condes(G,phi,per,opts);