% Test 2
% SISO, continuous, unstable
% Bode plots should be identical for PID/PI
% Performance should be improved for Lag/Gen ('D' term added)

phitype = 2; % 0: pid, 1: pi, 2: laguerre (4), 3: generalized (5)
ctype = 2; % 0: default, 1: given c, 2: given b
pertype = 0; % 0: LS, 1: Hinf

addpath('../../toolbox')
clear G phi per

disp('SISO, continuous, unstable')


s=tf('s');

G=(s+1)*(s+10)/((s+2)*(s+4)*(s-1));

Ld=2*(s+1)/s/(s-1);

W{1}=2/(20*s+1)^2;
W{2}=0.8*(1.1337*s^2+6.8857*s+9)/((s+1)*(s+10));
W{3}=tf(0.05);

opt=condesopt('gamma',[0.2 1.8 0.001],'lambda',[1 1 0 0],'nq',30);

for phitype=2:3
    for ctype=0:2
        for pertype=0:1

            switch ctype
                case 0
                    Ccell = @(x) {'c',[1,zeros(1,x-1)]};
                case 1
                    Ccell = @(x) {'c', ones(1,x)};
                case 2
                    Ccell = @(x) {'b',(1:x)'};
            end

            switch phitype
                case 0
                    x = 2;
                    phi_ss = conphi('pid',0.01,'s',[],'ss',Ccell(x));
                    phi = conphi('pid',0.01,'s');
                case 1
                    x = 1;
                    phi_ss = conphi('pi',[],'s',[],'ss',Ccell(x));
                    phi = conphi('pi',[],'s');
                case 2
                    x = 8;
                    phi_ss = conphi('lag',[2 x-1],'s',1/s,'ss',Ccell(x));
%                     phi_ss.phi(end) = tf(0,1);
                    phi = conphi('lag',[2 x-1],'s',1/s);
                case 3
                    n = [2 2 2 2 3 4];
                    x = length(n)+1;

                    phi_ss = conphi('gen',n,'s',1/s,'ss',Ccell(x));
%                     phi_ss.phi(end) = tf(0,1);
                    phi = conphi('gen',n,'s',1/s);
            end

            switch pertype 
                case 0
                    per = conper('LS',0.3,Ld);
                case 1
                    W{1} = 1/s;
                    per = conper('Hinf',W,Ld);
            end


            K_ss = condes(G,phi_ss,per);
            K = condes(G,phi,per);

            figure; bode(feedback(G*K_ss,1),feedback(G*K,1))
            title(['phi: ',num2str(phitype),', C: ',num2str(ctype),', per: ',num2str(pertype)])
        end
    end
end
