% Test 4
% SISO, discrete, unstable
% Bode plots should be identical for PID/PI
% Performance should be improved for Lag/Gen ('D' term added)

phitype = 2; % 0: pid, 1: pi, 2: laguerre (4), 3: generalized (5)
ctype = 2; % 0: default, 1: given c, 2: given b
pertype = 0; % 0: LS, 1: Hinf

addpath('../../toolbox')
clear G phi per W

disp('SISO, discrete, unstable, yalmip')

Ts = 0.005;
z = tf('z',Ts);

G= c2d((s+1)*(s+10)/((s+2)*(s+4)*(s-1)),Ts);

Ld=2*(s+1)/s/(s-1);

W{1}=2/(20*s+1)^2;
W{2}=0.8*(1.1337*s^2+6.8857*s+9)/((s+1)*(s+10));
W{3}=tf(0.05);

opt=condesopt('gamma',[0.2 3 0.001],'lambda',[1 1 0 0],'nq',[],'yalmip','on');
opt2=condesopt('gamma',[0.2 3 0.001],'lambda',[1 1 0 0],'yalmip','on');

for phitype=2:3
    for ctype=0:2
        for pertype=0:1

            switch ctype
                case 0
                    Ccell = @(x) {'c',[1,zeros(1,x-1)]};
                case 1
                    Ccell = @(x) {'c', ones(1,x)};
                case 2
                    Ccell = @(x) {'b',ones(x,1)};
            end

            switch phitype
                case 0
                    x = 2;
                    phi_ss = conphi('pid',Ts,'z',[],'ss',Ccell(x));
                    phi = conphi('pid',Ts,'z');
                case 1
                    x = 1;
                    phi_ss = conphi('pi',Ts,'z',[],'ss',Ccell(x));
                    phi = conphi('pi',Ts,'z');
                case 2
                    x = 5;
                    phi_ss = conphi('lag',[Ts 0 x-1],'z',z/(z-1),'ss',Ccell(x));
                    phi_ss.phi(end) = tf(0,1);
                    phi = conphi('lag',[Ts 0 x-1],'z',z/(z-1));
                case 3
                    n = [0.1 0.2 0.3 0.4];
                    x = length(n)+1;

                    phi_ss = conphi('gen',[Ts n],'z',z/(z-1),'ss',Ccell(x));
                    phi_ss.phi(end) = tf(0,1);
                    phi = conphi('gen',[Ts n],'z',z/(z-1));
            end

            switch pertype 
                case 0
                    per = conper('LS',0.3,Ld);
                case 1
                    W{1} = tf(0.05,1);
                    per = conper('Hinf',W,Ld);
            end


            K_ss = condes(G,phi_ss,per,opt);
            K = condes(G,phi_ss,per,opt2);

            figure; bode(feedback(G*K_ss,1),feedback(G*K,1))
            title(['phi: ',num2str(phitype),', C: ',num2str(ctype),', per: ',num2str(pertype)])
        end
    end
end
