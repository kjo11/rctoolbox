% Test 5
% Loop -- FRD

addpath('../toolbox')
addpath(genpath('../../matlab_tools'))
clear W G phi per w



%% Constants
nq=20;
realtol=10e-8;
Ts=0.04;
n=4;% order
xi=0;% Pole

s=tf('s');

load data_ex10

%% Model and options
Gdata = iddata(y,u,Ts); % FR data with uncertainty
w{1}=linspace(10e-4,78.539816339744830,128);% frequency points
G= spa(Gdata,200,w{1});    

Wc=tf(1+1/s);%weighted function
W{1}=c2d(Wc,Ts);
W{2}=tf(0);
W{3}=tf(0);
lambda_mat=[1 0 0 0];

g_max=4; g_min=2.7; g_tol = 0.01;
phi = conphi('lag',[Ts 0 n],'z',[],'tf');

%% Loop
for j=1:2
    if j==1
        yalmipstr='on';
        nq=[];
        fprintf('yalmip\n');
    else
        yalmipstr='off';
        nq=20;
        fprintf('no yalmip\n')
    end
    
    for k=1:size(lambda_mat,1)
        lambda=lambda_mat(k,:);
        fprintf('lambda %i\n',k)
        
        opts = condesopt('nq',nq,'w',w,'gamma',[g_min g_max g_tol],'lambda',lambda);
        per = conper('Hinf',W);
        [K,sol] = condes(G,phi,per,opts);
        
        plot_Hinfcons(G,K,W,lambda,sol.gamma,w)
        pause
    end     
end
