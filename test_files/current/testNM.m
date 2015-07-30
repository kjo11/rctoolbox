addpath('../../toolbox')
s = tf('s');

phi = conphi('lag',[0.2 6],'s',1/s,'tf');
W{1} = 4/s;
per = conper('Hinf',W);

G{1}{1} = exp(-s)*(s+1)/(s-1)/(s+10);
G{1}{2} = s/(s+1);

K = condes(G,phi,per);