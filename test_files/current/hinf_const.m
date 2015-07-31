addpath('../../toolbox')
addpath(genpath('../../../matlab_tools'))
s = tf('s');

phi = conphi('lag',[20 6],'s',[],'tf');
W = cell(2,1);
x=0.009;
W{1} = tf(0.33*(s+1515*x)/(s+x));
desBW = 4.5;
NF=(10*desBW)/20;
DF=(10*desBW)*50;
W{2}=tf([1/NF^2 2*0.707/NF 1], [1/DF^2 2*0.707/DF 1]);
W{2}=W{2}/abs(freqresp(W{2},10*desBW));

per = conper('Hinf',W);

% G{1}{1} = exp(-s)*(s+1)/(s-1)/(s+10);
% G{1}{2} = s/(s+1);
% G = (s+1)/(s-1)/(s+10);
G=2/(s-2)*tf(1,[.06 1]);%nominal system

opts = condesopt('gamma',[0.7 2 0.01],'lambda',[1 1 0 0],'yalmip','off','w',logspace(-2,4,200));

[K,sol] = condes(G,phi,per,opts);

S = feedback(1,K*G);
T = feedback(K*G,1);
figure; bode(W{1}*S,tf(sol.gamma,1))
figure; bode(W{2}*T,tf(sol.gamma,2))