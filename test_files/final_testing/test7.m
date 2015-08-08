% Test 7
% Loop

addpath('../toolbox')
addpath(genpath('../../matlab_tools'))
clear W G phi per w


%% Constants
nq=20;
realtol=10e-8;

n=4;% order
xi=0;% Pole

s=tf('s');

load data_ex10 %loading time domain I/O data

Ts=0.04;       %Sampling time
z=tf('z',Ts);  


for i=3:3
    clear G W w
    switch i
        case 1
            fprintf('stable \n')
%             G{1}{1}=(s+10)/((s+2)*(s+4));
%             G{1}{2}=tf(1);
            G=(s+10)/((s+2)*(s+4));
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
%             GG=G{1}{1};
            GG=G;
        case 2
            fprintf('unstable \n')
            G{1}{1}=(s+1)*(s+10)/((s+2)*(s+4));
            G{1}{2}=s-1;
            w{1}=logspace(-3,3,100);

            W{1}=2/(20*s+1)^2;
            W{2}=0.8*(1.1337*s^2+6.8857*s+9)/((s+1)*(s+10));
            W{3}=tf(0.05);
            
            lambda_mat=[1 1 1 0; 0 1 0 0; 0 0 0 0];
            g_max=1; g_min=0.5; g_tol = 0.01;
            phi = conphi('lag',[2 n],'s',[],'tf');
            GG=G{1}{1}/G{1}{2};
        case 3
            fprintf('ID \n')
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
            GG=G;
    end

    
    for j=2:2
        if j==1
            yalmipstr='on';
            ntheta=[];
            fprintf('yalmip\n')
        else
            yalmipstr='off';
            ntheta=5;
            fprintf('no yalmip\n')
        end
        
        
        for k=1:size(lambda_mat,1)
            lambda=lambda_mat(k,:);
            fprintf('lambda %i\n',k)

            %% condes
            opts = condesopt('nq',nq,'ntheta',ntheta,'TFtol',realtol,'w',w,'gamma',[g_min g_max g_tol],'lambda',lambda);
            per = conper('Hinf',W);
            [K,sol] = condes(GG,phi,per,opts);

            %% plot
            S = feedback(1,K*GG);
            T = 1-S;
            U = K*S;


            if sum(lambda)==0
                figure; bode(W{1}*S,tf(sol.gamma),w{1})
                figure; bode(W{2}*T,tf(sol.gamma),w{1})
                figure; bode(W{3}*U,tf(sol.gamma),w{1})
            else
                figure; bode(lambda(1)*W{1}*S + lambda(2)*W{2}*T + lambda(3)*W{3}*U,tf(sol.gamma),w{1})
                if lambda(1)==0
                    figure; bode(W{1}*S,tf(1),w{1})
                end
                if lambda(2)==0
                    figure; bode(W{2}*T,tf(1),w{1})
                end
                if lambda(3)==0
                    figure; bode(W{3}*U,tf(1),w{1})
                end
            end

        end
    end
end