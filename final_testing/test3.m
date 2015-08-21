% Test 3
% SISO, discrete, stable


phitype = 2; % 0: pid, 1: pi, 2: laguerre (4), 3: generalized (5)
pertype = 0; % 0: LS, 1: Hinf, 2: GPhC, 3: GPh

addpath('../toolbox')
clear G phi per W

disp('SISO, discrete, stable')

Ts = 0.005;

z=tf('z',Ts);
G=c2d(1/((s+1)^3),Ts);
P = z^-5*G;
H = G-P;

opts = condesopt('gamma',[0.2 4 0.1]);

Ld = 1/s;

for phitype=0:3
    for pertype=0:2

        switch phitype
            case 0
                phi_sp = conphi('pid',[Ts],'z',[],'sp',H);
                phi = conphi('pid',[Ts],'z');
            case 1
                phi_sp = conphi('pi',[Ts],'z',[],'sp',H);
                phi = conphi('pi',[Ts],'z');
            case 2
                x = 5;
                phi_sp = conphi('lag',[Ts 0.2 x-1],'z',z/(z-1),'sp',H);
                phi = conphi('lag',[Ts 0.2 x-1],'z',z/(z-1));
            case 3
                n = [0.1 0.2 0.3 0.2 0.2];
                phi_sp = conphi('gen',[Ts n],'z',z/(z-1),'sp',H);
                phi = conphi('gen',[Ts n],'z',z/(z-1));
        end

        switch pertype 
            case 0
                per = conper('LS',0.3,Ld);
            case 1
                W{1} = tf(0.05,1);
                per = conper('Hinf',W,Ld);
            case 2
                per = conper('GPhC',[2 45 0.1],Ld);
        end


        C_sp = condes(P,phi_sp,per,opts);
        K_sp = feedback(C_sp,H);
        K = condes(P,phi,per,opts);

        figure; bode(feedback(P*K_sp,1),feedback(P*K,1))
        title(['phi: ',num2str(phitype),', per: ',num2str(pertype)])
    end
end
