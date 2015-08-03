% Test 3
% SISO, discrete, stable
% Bode plots should be identical for PID/PI
% Performance should be improved for Lag/Gen ('D' term added)

phitype = 2; % 0: pid, 1: pi, 2: laguerre (4), 3: generalized (5)
ctype = 2; % 0: default, 1: given c, 2: given b
pertype = 0; % 0: LS, 1: Hinf, 2: GPhC, 3: GPh

addpath('../../toolbox')
clear G phi per

disp('SISO, discrete, stable')

Ts = 0.005;

z=tf('z');
G=absorbDelay(c2d(exp(-5*s)/(s*(s+1)^3),Ts));

for phitype=0:3
    for ctype=0:2
        for pertype=0:3

            switch ctype
                case 0
                    Ccell = @(x) {'c',[zeros(1,x-1),1]};
                case 1
                    Ccell = @(x) {'c', ones(1,x)};
                case 2
                    Ccell = @(x) {'b',(1:x)'};
            end

            switch phitype
                case 0
                    x = 2;
                    phi_ss = conphi('pid',0.2,'z',[],'ss',Ccell(x));
                    phi = conphi('pid',0.2,'z');
                case 1
                    x = 1;
                    phi_ss = conphi('pi',[],'z',[],'ss',Ccell(x));
                    phi = conphi('pi',[],'z');
                case 2
                    x = 5;
                    phi_ss = conphi('lag',[2 x-1],'z',z/(z-1),'ss',Ccell(x));
                    phi_ss.phi(end) = tf(0,1);
                    phi = conphi('lag',[2 x-1],'z',z/(z-1));
                case 3
                    n = [2 2 2 2];
                    x = length(n)+1;

                    phi_ss = conphi('gen',n,'z',z/(z-1),'ss',Ccell(x));
                    phi_ss.phi(end) = tf(0,1);
                    phi = conphi('gen',n,'z',z/(z-1));
            end

            switch pertype 
                case 0
                    per = conper('LS',0.3,0.1/s^2);
                case 1
                    W{1} = 5/s;
                    per = conper('Hinf',W,0.1/s^2);
                case 2
                    per = conper('GPhC',[2 45 0.1],0.1/s^2);
                case 3
                    per = conper('GPhC',[2 45]);
            end


            K_ss = condes(G,phi_ss,per);
            K = condes(G,phi,per);

            figure; bode(K_ss,K)
        end
    end
end
