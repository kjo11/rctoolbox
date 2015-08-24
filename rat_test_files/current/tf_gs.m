addpath('../../toolbox/')
addpath(genpath('../../../matlab_tools'))
clear G phi per W

G{1}=1/(s+10);
G{2}=2/(s+10);

W{1}=tf(0.05);

phi = conphi('lag',[2 5],'s',[],'tf');
per = conper('Hinf',W);
gs=[1; 2];
opt = condesopt('gamma',[0.2 1 0.01],'lambda',[1 0 0 0],'np',1,'gs',gs,'yalmip','on','ntheta',[]);

[K,sol]=condes(G,phi,per,opt);

%%
S1 = feedback(1,(K{1}+gs(1)*K{2})*G{1});
S2 = feedback(1,(K{1}+gs(2)*K{2})*G{2});

figure; bode(W{1}*S1,W{1}*S2,tf(sol.gamma))