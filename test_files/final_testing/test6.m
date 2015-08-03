% Test 6
% MIMO (1x2), continuous
% Bode plots should be identical for C given
% Otherwise state space should have slightly poorer performance

phitype = 2; % 0: pid, 1: pi, 2: laguerre (4), 3: generalized (5)
ctype = 2; % 0: default, 1: given c, 2: given b
pertype = 0; % 0: LS, 1: Hinf

addpath('../../toolbox')
clear G phi per

disp('MIMO (1x2), continuous')

s=tf('s');
G=[5*exp(-3*s)/(4*s+1) 2.5*exp(-5*s)/(15*s+1)];

Ld = 1/(30*s);

W{1}=tf(0.5);
W{2}=0.5*(2*s+1)/(s+1);

options = condesopt ('lambda',[1 1 0 0],'gamma',[0.5,2,0.01]);


for phitype=0:3
    for ctype=0:2
        for pertype=0:3

            switch ctype
                case 0
                    Ccell = @(x) {'c',[1,zeros(1,x-1)]};
                case 1
                    Ccell = @(x) {'c', ones(1,x)};
                case 2
                    Ccell = @(x) {'b',[(1:x); (1:x)]'};
            end

            switch phitype
                case 0
                    x = 2;
                    phi_ss = conphi('pid',0.01,'z',[],'ss',Ccell(x));
                    phi{1,1} = conphi('pid',0.01,'z');
                    phi{1,2} = phi{1,1};
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
                    n = [0.1 0.2 0.3 0.4];
                    x = length(n)+1;

                    phi_ss = conphi('gen',n,'z',z/(z-1),'ss',Ccell(x));
                    phi_ss.phi(end) = tf(0,1);
                    phi = conphi('gen',n,'z',z/(z-1));
            end

            switch pertype 
                case 0
                    per{1} = conper('LS',0.3,Ld);
                    per{2} = conper('LS',0.3,Ld);
                case 1
                    W{1} = 5/s;
                    per = conper('Hinf',W,Ld);
            end


            K_ss = condes(G,phi_ss,per);
            K = condes(G,phi,per);

            figure; bode(K_ss,K)
        end
    end
end
