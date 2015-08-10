% Test 8
% Uncertainty in M

addpath('../toolbox')
addpath(genpath('../../matlab_tools'))
clear W G phi per w

%% Constants
nq=20;
realtol=10e-8;

order=10;% order
xi=2;% Pole

s=tf('s');

%% Model and data generation
Gorig=(s+10)*(s+1)/((s+2)*(s+4)*(s-1));
K=1+1/s;
dt = 0.01;

r = prbs(5,20);
n = 0.1*rand(size(r));
t = 0:dt:dt*(length(r)-1);

y = lsim(feedback(K*Gorig,1),r,t) + n;
u = lsim(feedback(K,Gorig),r,t);

Ndata = iddata(y,r,dt);
Mdata = iddata(u,r,dt);
Gdata = iddata(y,u,dt);

N = spa(Ndata);
M = spa(Mdata);

G{1}{1} = N;
G{1}{2} = M;

G2 = spa(Gdata);


W{1}=2/(20*s+1)^2;
W{2}=0.8*(1.1337*s^2+6.8857*s+9)/((s+1)*(s+10));
W{3}=tf(0.05);


lambda_mat=[1 0 0 0];

g_max=0.3; g_min=0.01; g_tol = 0.01;
phi = conphi('lag',[dt 0 order],'z',[],'tf');

ntheta = 5;
lambda=lambda_mat;

opts = condesopt('nq',nq,'ntheta',ntheta,'TFtol',realtol,'gamma',[g_min g_max g_tol],'lambda',lambda);
per = conper('Hinf',W);

[K,sol] = condes(G,phi,per,opts);
[K2,sol2] = condes(G2,phi,per,opts);

figure; bode(K,K2)
%% Loop
% for j=1:2
%     if j==1
%         yalmipstr='on';
%         ntheta=[];
%         fprintf('yalmip\n');
%     else
%         yalmipstr='off';
%         ntheta=20;
%         fprintf('no yalmip\n')
%     end
%     
%     for k=1:size(lambda_mat,1)
%         lambda=lambda_mat(k,:);
%         fprintf('lambda %i\n',k)
%         
%         opts = condesopt('nq',nq,'ntheta',ntheta,'TFtol',realtol,'w',w,'gamma',[g_min g_max g_tol],'lambda',lambda);
%         per = conper('Hinf',W);
%         [K,sol] = condes(GG,phi,per,opts);
%         
%         plot_Hinfcons(GG,K,W,lambda,sol.gamma,w)
%     end     
% end
