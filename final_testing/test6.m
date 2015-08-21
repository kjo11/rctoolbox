% Test 6
% MIMO (1x2), continuous

phitype = 2; % 0: pid, 1: pi, 2: laguerre (4), 3: generalized (5)
ctype = 2; % 0: default, 1: given c, 2: given b
pertype = 0; % 0: LS, 1: Hinf

addpath('../toolbox')
clear G phi per W

disp('MIMO (1x2), continuous')

s=tf('s');
G = [5/(4*s+1) 2.5/(15*s+1)];
P=[5*exp(-3*s)/(4*s+1) 2.5*exp(-5*s)/(15*s+1)];
H = G - P;

Ld = 1/(30*s);

W{1}=tf(0.5);
W{2}=0.5*(2*s+1)/(s+1);
W{3} = tf(0.001);
opt = condesopt ('lambda',[0 0 1 0],'gamma',[0.5,4,0.1]);


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
                per{1} = conper('LS',0.3,Ld);
                per{2} = conper('LS',0.3,Ld);
            case 1
                W{1} = tf(0.01,1);
                per = conper('Hinf',W,Ld);
        end


        C_sp = condes(P,phi_sp,per,opt);
        K_sp = feedback(C_sp,H);
        K = condes(P,phi,per,opt);

        figure; bode(K_sp,K)
        title(['phi: ',num2str(phitype),', per: ',num2str(pertype)])
    end
end
