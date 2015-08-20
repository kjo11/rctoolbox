% Test 5
% MIMO (2x1), continuous
% Bode plots should be identical for B given
% Otherwise state space should have slightly poorer performance

phitype = 2; % 0: pid, 1: pi, 2: laguerre (4), 3: generalized (5)
ctype = 2; % 0: default, 1: given c, 2: given b
pertype = 0; % 0: LS, 1: Hinf

addpath('../toolbox')
clear G phi per W

disp('MIMO (2x1), continuous')

s=tf('s');
G=[5*exp(-3*s)/(4*s+1); -4*exp(-6*s)/(20*s+1)];

Ld = 1/(30*s);

W{1}=tf(0.5);
W{2}=0.5*(2*s+1)/(s+1);

options = condesopt ('lambda',[1 1 0 0],'gamma',[0.5,2,0.01],'gbands','off');


for phitype=0:3
    for ctype=0:2
        for pertype=0:1

            switch ctype
                case 0
                    Ccell = @(x) {'c',[1,zeros(1,x-1)]};
                case 1
                    Ccell = @(x) {'c', ones(1,x)};
                case 2
                    Ccell = @(x) {'b',[(0:x-1)',ones(x,1)]};
            end

            switch phitype
                case 0
                    x = 2;
                    phi_ss = conphi('pid',0.01,'s',[],'ss',Ccell(x));
                    phi{1,1} = conphi('pid',0.01,'s');
                    phi{1,2} = phi{1,1};
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
                    n = [0.1 0.2 0.3 0.4];
                    x = length(n)+1;

                    phi_ss = conphi('gen',n,'s',1/s,'ss',Ccell(x));
%                     phi_ss.phi(end) = tf(0,1);
                    phi = conphi('gen',n,'s',1/s);
            end
            
            switch pertype
                case 0
                    per=cell(2,1);
                    per{1} = conper('LS',0.1,Ld);
                    per{2} = conper('LS',0.1,Ld);
                case 1
                    W{1} = tf(0.1,1);
                    per = conper('Hinf',W,Ld);
            end


            K_ss = condes(G,phi_ss,per,options);
            K = condes(G,phi,per,options);

            figure; bode(feedback(G*K_ss,ones(size(G,1))),feedback(G*K,ones(size(G,1))))
%             figure; bode(K_ss,K)
            title(['phi: ',num2str(phitype),', C: ',num2str(ctype),', per: ',num2str(pertype)])
        end
    end
end
