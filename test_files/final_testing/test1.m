% Test 1
% SISO, continuous, stable
% Bode plots should be identical for PID/PI
% Performance should be improved for Lag/Gen ('D' term added)

phitype = 2; % 0: pid, 1: pi, 2: laguerre (4), 3: generalized (5)
ctype = 2; % 0: default, 1: given c, 2: given b
pertype = 0; % 0: LS, 1: Hinf, 2: GPhC, 3: GPh

addpath('../../toolbox')
clear G phi per

disp('SISO, continuous, stable')

s=tf('s');
G=exp(-s)/((s+1)^3);
Ld = 1/s;

for phitype=2:3
    for ctype=0:2
        for pertype=0:3

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
                    phi_ss = conphi('pid',0.2,'s',[],'ss',Ccell(x));
                    phi = conphi('pid',0.2,'s');
                case 1
                    x = 1;
                    phi_ss = conphi('pi',[],'s',[],'ss',Ccell(x));
                    phi = conphi('pi',[],'s');
                case 2
                    x = 5;
                    phi_ss = conphi('lag',[2 x-1],'s',1/s,'ss',Ccell(x));
%                     phi_ss.phi(end) = tf(0,1);
                    phi = conphi('lag',[2 x-1],'s',1/s);
                case 3
                    n = [2 2 2 2];
                    x = length(n)+1;

                    phi_ss = conphi('gen',n,'s',1/s,'ss',Ccell(x));
%                     phi_ss.phi(end) = tf(0,1);
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


            K_ss = condes(G,phi_ss,per);
            K = condes(G,phi,per);

            figure; bode(feedback(G*K_ss,1),feedback(G*K,1))
            title(['phi: ',num2str(phitype),', C: ',num2str(ctype),', per: ',num2str(pertype)])
        end
    end
end
