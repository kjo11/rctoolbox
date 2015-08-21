% Test 2
% gain-scheduled -- multiple theta

addpath('../toolbox')
addpath(genpath('../../matlab_tools'))
clear W G phi per w



%% Constants

n=4;% order
xi=0;% Pole

s=tf('s');

%% Model and options
G{1}=(s+10)/((s+2)*(s+4));
G{2}=(s+11)/((s+2)*(s+4));
G{3}=(s+12)/((s+2.1)*(s+4));

for i=1:length(G)
    P{i} = G{i}*exp(-s);
end

H = G{1} - P{1};

gs = [1 1; 2 0; 2 2];
np = [1 2];

w=logspace(-3,3,10);

W{1}=2/(20*s+1)^2;
W{2}=0.8*(1.1337*s^2+6.8857*s+9)/((s+1)*(s+10));
W{3}=tf(0.05);

Ld = 1/s;


lambda_mat = [1 1 1 0; 1 0 0 0; 0 1 0 0];
g_max=1; g_min=0.5; g_tol = 0.01;
phi = conphi('lag',[2 n],'s',1/s,'sp',H);


%% Loop
for j=1:2
    if j==1
        yalmipstr='on';
        nq=[];
        fprintf('yalmip\n');
    else
        yalmipstr='off';
        nq=5;
        fprintf('no yalmip\n')
    end
    
    for k=1:size(lambda_mat,1)
        lambda=lambda_mat(k,:);
        fprintf('lambda %i\n',k)
        
        opts = condesopt('nq',nq,'w',w,'gamma',[g_min g_max g_tol],'lambda',lambda,'np',np,'gs',gs);
        per = conper('Hinf',W,Ld);
        [C,sol] = condes(P,phi,per,opts);
        
        
        eval_Hinfcons(P,C,W,lambda,sol.gamma,w,gs,np,H)
    end     
end

