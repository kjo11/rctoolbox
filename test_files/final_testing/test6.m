% Test 6
% Loop -- gain-scheduled

addpath('../toolbox')
addpath(genpath('../../matlab_tools'))
clear W G phi per w



%% Constants
nq=20;
realtol=10e-8;

n=4;% order
xi=0;% Pole

s=tf('s');

%% Model and options
G{1}=(s+10)/((s+2)*(s+4));
G{2}=(s+11)/((s+2)*(s+4));

gs = [1; 2];

w{1}=logspace(-3,3,100);

W{1}=2/(20*s+1)^2;
W{2}=0.8*(1.1337*s^2+6.8857*s+9)/((s+1)*(s+10));
W{3}=tf(0.05);

lambda_mat=[1 1 1 0;
            1 1 0 0;
            1 0 1 0;
            0 1 1 0;
            1 0 0 0;
            0 1 0 0;
            0 0 1 0;
            0 0 0 0];
g_max=1; g_min=0.5; g_tol = 0.01;
phi = conphi('lag',[2 n],'s',1/s,'tf');


%% Loop
for j=1:2
    if j==1
        yalmipstr='on';
        ntheta=[];
        fprintf('yalmip\n');
    else
        yalmipstr='off';
        ntheta=5;
        fprintf('no yalmip\n')
    end
    
    for k=1:size(lambda_mat,1)
        lambda=lambda_mat(k,:);
        fprintf('lambda %i\n',k)
        
        opts = condesopt('nq',nq,'ntheta',ntheta,'TFtol',realtol,'w',w,'gamma',[g_min g_max g_tol],'lambda',lambda,'np',1,'gs',gs);
        per = conper('Hinf',W);
        [K,sol] = condes(G,phi,per,opts);
        
        plot_Hinfcons(G,K,W,lambda,sol.gamma,w,gs)
    end     
end
