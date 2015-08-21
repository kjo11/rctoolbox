% Test 5
% MIMO (2x1), continuous

phitype = 2; % 0: pid, 1: pi, 2: laguerre (4), 3: generalized (5)
pertype = 0; % 0: LS, 1: Hinf

addpath('../toolbox')
clear G phi per W

disp('MIMO (2x1), continuous')

s=tf('s');
G=[5*exp(-3*s)/(4*s+1); -4*exp(-6*s)/(20*s+1)];

Ld = 1/(30*s);

W{1}=tf(0.5);
W{2}=0.5*(2*s+1)/(s+1);
W{3} = tf(0.001);
W{4} = tf(0.001);

options = condesopt ('lambda',[1 1 0 0],'gamma',[1,4,0.1],'gbands','off');


for phitype=0:3
    for pertype=0:1

        switch phitype
            case 0
                phi_ss = conphi('pid',0.01,'s',[],'sp',H);
                phi{1,1} = conphi('pid',0.01,'s');
                phi{1,2} = phi{1,1};
            case 1
                phi_ss = conphi('pi',[],'s',[],'sp',H);
                phi = conphi('pi',[],'s');
            case 2
                x = 5;
                phi_ss = conphi('lag',[2 x-1],'s',1/s,'sp',H);
                phi = conphi('lag',[2 x-1],'s',1/s);
            case 3
                n = [0.1 0.2 0.3 0.4];
                phi_ss = conphi('gen',n,'s',1/s,'sp',H);
                phi = conphi('gen',n,'s',1/s);
        end

        switch pertype
            case 0
                per=cell(2,1);
                per{1} = conper('LS',0.1,Ld);
                per{2} = conper('LS',0.1,Ld);
            case 1
                per = conper('Hinf',W,Ld);
        end


        C_sp = condes(P,phi_ss,per,options);
        K_sp = feedback(C_sp,H);
        K = condes(P,phi,per,options);

        figure; bode(feedback(P*K_sp,ones(size(G,1))),feedback(P*K,ones(size(G,1))))
        title(['phi: ',num2str(phitype),', per: ',num2str(pertype)])
    end
end
