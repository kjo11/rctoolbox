addpath('../../toolbox/')
clear G phi per W

G{1}=1/(s+10);
G{2}=2/(s+10);

W{1}=tf(0.05);

phi = conphi('lag',[2 5],'s',[],'tf');
per = conper('Hinf',W);
opt = condesopt('gamma',[0.2 1 0.01],'lambda',[1 0 0 0],'np',1,'gs',[1; 2]);

K=condes(G,phi,per,opt);