% Test 1
% SISO, continuous, stable

phitype = 2; % 0: pid, 1: pi, 2: laguerre (4), 3: generalized (5)
ctype = 2; % 0: default, 1: given c, 2: given b
pertype = 0; % 0: LS, 1: Hinf, 2: GPhC, 3: GPh

addpath('../toolbox')
clear G phi per

disp('SISO, continuous, stable')

s=tf('s');
G=1/((s+1)^3);
P = exp(-s)*G;
H = G-P;

Ld = 1/s;

for phitype=0:3
    for pertype=0:3

        switch phitype
            case 0
                x = 2;
                phi_sp = conphi('pid',0.2,'s',[],'sp',H);
                phi = conphi('pid',0.2,'s');
            case 1
                x = 1;
                phi_sp = conphi('pi',[],'s',[],'sp',H);
                phi = conphi('pi',[],'s');
            case 2
                x = 5;
                phi_sp = conphi('lag',[2 x-1],'s',1/s,'sp',H);
                phi = conphi('lag',[2 x-1],'s',1/s);
            case 3
                n = [2 2 2 2];
                x = length(n)+1;

                phi_sp = conphi('gen',n,'s',1/s,'sp',H);
                phi = conphi('gen',n,'s',1/s);
        end

        switch pertype 
            case 0
                per = conper('LS',0.3,Ld);
            case 1
                W{1} = tf(0.5,1);
                per = conper('Hinf',W,Ld);
            case 2
                per = conper('GPhC',[1.2 30 0.5],Ld);
            case 3
                per = conper('GPhC',[1.5 15]);
        end


        C_sp = condes(G,phi_sp,per);
        K_sp = feedback(C_sp,H);
        K = condes(G,phi,per);

        figure; bode(feedback(G*K_sp,1),feedback(G*K,1))
        title(['phi: ',num2str(phitype),', C: ',num2str(ctype),', per: ',num2str(pertype)])
    end
end
