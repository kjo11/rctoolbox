% Test 8
% MIMO (3x3), continuous

phitype = 2; % 0: pid, 1: pi, 2: laguerre (4), 3: generalized (5)
pertype = 0; % 0: LS, 1: Hinf

addpath('../toolbox')
addpath(genpath('../../matlab_tools'))
clear G phi per

disp('MIMO (3x3), continuous')

s=tf('s');
P=[5*exp(-3*s)/(4*s+1) 2.5*exp(-5*s)/(15*s+1) tf(0,1); -4*exp(-6*s)/(20*s+1) exp(-4*s)/(5*s+1) tf(0,1); tf(0,1) tf(0,1) 5/(s+1)];
G=[5/(4*s+1) 2.5/(15*s+1) tf(0,1); -4/(20*s+1) 1/(5*s+1) tf(0,1); tf(0,1) tf(0,1) 5/(s+1)];
H = G - P;

Ld = 1/(30*s);

W{1}=tf(0.5);
W{2}=0.5*(2*s+1)/(s+1);

options = condesopt ('lambda',[1 1 0 0],'gamma',[0.5,3,0.1],'gbands','on','yalmip','on',nq,[]);


for phitype=0:3
    for pertype=0:1
        switch phitype
            case 0
                phi_sp = conphi('pid',0.01,'s',[],'sp',H);
                phi{1,1} = conphi('pid',0.01,'s');
                phi{1,2} = phi{1,1};
            case 1
                phi_sp = conphi('pi',[],'s',[],'sp',H);
                phi = conphi('pi',[],'s');
            case 2
                x = 5;
                phi_sp = conphi('lag',[2 x-1],'s',1/s,'sp',H);
                phi = conphi('lag',[2 x-1],'s',1/s);
            case 3
                n = [0.1 0.2 0.3 0.4];
                phi_sp = conphi('gen',n,'s',1/s,'sp',H);
                phi = conphi('gen',n,'s',1/s);
        end

        switch pertype
            case 0
                per = cell(2,1);
                per{1} = conper('LS',0.2,Ld);
                per{2} = conper('LS',0.2,Ld);
                per{3} = conper('LS',0.2,Ld);
            case 1
                W{1} = tf(0.01,1);
                per = conper('Hinf',W,Ld);
        end


        C_sp = condes(G,phi_sp,per,options);
        K_sp = feedback(C_sp,H);
        K = condes(G,phi,per,options);

        figure; bode(feedback(P*K_sp,ones(size(G,1))),feedback(P*K,ones(size(G,1))))
        title(['phi: ',num2str(phitype),', per: ',num2str(pertype)])


    end
end
