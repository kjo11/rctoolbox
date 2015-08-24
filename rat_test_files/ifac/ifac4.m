clc
clear;
warning off

s=tf('s');
G(1,1)=2/(s-2);%nominal system
Pnom=G;
p(1) = Pnom*tf(1,[.06 1]);              % extra lag
p(2) = Pnom;                            % time delay
p(3) = Pnom*tf(50^2,[1 2*.1*50 50^2]);  % high frequency resonance
p(4) = Pnom*tf(70^2,[1 2*.2*70 70^2]);  % high frequency resonance
p(5) = tf(2.4,[1 -2.2]);                % pole/gain migration
p(6) = tf(1.6,[1 -1.8]);                % pole/gain migration
p(7) = Pnom;
Parray=stack(1,p(1),p(2),p(3),p(4),p(5),p(6));
[num,num,num_submodel]=size(Parray);

F=cell(num_submodel,1);
k=[2 1 3 3 1 1,1];% order of system
for i=1:num_submodel % Create N_i and M_i 
    F{i}=1;
    for m=1:k(i)
        F{i}=conv(F{i},[1 100]);% !!!The  order of the polynomia should equal 
%                                 to the order of the plant.From theorotical view point, 
%                                 it doesnot change the result, but in application it affect the computation
    end
    [num,dem]=tfdata(p(i),'v');
    N(i)=tf(num,F{i});
    M(i)=tf(dem,F{i});
end
N(2)=N(2)*exp(-0.04*s);% p2 has time delay

desBW=4.5;
% W(1,1)=tf(makeweight(500,desBW,0.33));
W(1,1)=4/s;
NF=(10*desBW)/20;
DF=(10*desBW)*50;
W(2,1)=tf([1/NF^2 2*0.707/NF 1], [1/DF^2 2*0.707/DF 1]);
W(2,1)=W(2,1)/abs(freqresp(W(2,1),10*desBW));

%%%%%%%%%%%%%%%%%%%%%%%%% Setup of Controller %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xi=20; % kexi of laguerre
n=5; % number of basis functions
phi(1,1)=zpk(1);
for j=2:n+1
    phi(j,1)=sqrt(2*xi)*(s-xi)^(j-2)/(s+xi)^(j-1);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fs=s/(s+1);%inverse of pseudo integrater
%fs=tf(1);
w=[logspace(-3,4,200)]; %frequency points
nq=25; % %number of griding point of theta
phif=freqresp(phi,w);% num_basis*1*frequencypoint

Gf=freqresp(p,w);%
Nf=freqresp(N,w);%1*num_submodel*frequencypoint
Mf=freqresp(M,w);%
Wf=freqresp(W,w);%num_weight*1*frequencypoint
fsf=freqresp(fs,w);
[num,nr,nc]=size(phif);
f2=[zeros(1,2*num)];

%------------ Bisection algorithm to minimize gamma------------------------
gamma_opt=0;
g_max=0.9;
g_min=.85;
g_tol=1e-2;
gamma=g_max;
realtol=0.00001;
ops = optimset ('Largescale', 'on','MaxIter',100000,'TolFun',1e-8);
x_opt=0;

while g_max-g_min > g_tol

    A=[];
    b=[];  
    for i=1:num_submodel
    Wfgamma =inv(gamma)*Wf;
        for q=1:nq% gridding the theta
            for j=1:2*num
                if j<=num
                    %[[S] [T]]
                    phiGq(j,:)= [[squeeze(phif(j,1,:).*Nf(1,i,:))'],...
                      [squeeze(phif(j,1,:).*Nf(1,i,:))'+exp(1i*2*pi*q/nq)/cos(pi/nq)*squeeze(Wfgamma(2,1,:))'.*squeeze(phif(j,1,:).*Nf(1,i,:))'] ];% ST SS SU
                else
                    phiGq(j,:)= [[squeeze(phif(j-num,1,:).*fsf.*Mf(1,i,:))'+exp(1i*2*pi*q/nq)/cos(pi/nq)*squeeze(Wfgamma(1,1,:))'.*squeeze(phif(j-num,1,:).*fsf.*Mf(1,i,:))'],...
                        [squeeze(phif(j-num,1,:).*fsf.*Mf(1,i,:))'] ];%=
                end
            end
            A1=-real(transpose(phiGq));
            h=size(A1);
            b1=-realtol*ones(h(1),1);
            A = [A ; A1];
            b = [b ; b1];
        end 
    end
    
    [x,optval,xflag] = linprog(f2,A,b,[],[],[],[],[],ops);% solving the optimization
    if xflag==1
        x_opt = x;
        gamma_opt=gamma;optval_opt=optval;xflag_opt=xflag;
        g_max=gamma;
        disp(['gamma=', num2str(g_max)])
        gamma=mean([g_min,gamma]);
     else
        g_min=gamma;
        gamma=mean([g_max,gamma]);% enlarge the gamama
    end
end

X=minreal(x_opt(1:num)'*phi);Y=minreal((x_opt(1+num:2*num)'*phi));
K = minreal(X/Y/fs)
SS=norm(minreal(W(1,1)*feedback(1,K*Parray)),inf)
ST=norm(minreal(W(2,1)*feedback(K*Parray,1)),inf)

figure,hh=stepplot(minreal(feedback(1,Parray*K)),10/desBW);
P = timeoptions;
P.Title.String=[];
P.XLabel.FontSize=12;
P.YLabel.FontSize=12;
P.TickLabel.FontSize=12;
P.Grid='on';
setoptions(hh,P);

% figure;
% for i=1:num_submodel
%     hold on;
%     nyquist(minreal((X*N(i)+Y*fs*M(i))));
% 
%     for q=1:nq
%         hold on; 
%         nyquist(((X*N(i)+Y*fs*M(i))+exp(1i*2*pi*q/nq)*W(1,1)*inv(g_max)*Y*fs*M(i))) %SS
%     end
% end

% %Initialize Matlab Parallel Computing Enviornment by Xaero | Macro2.cn
% CoreNum=6; %????CPU???????????????CoreNum=2
% if matlabpool('size')<=0 %??????????????
% matlabpool('open','local',CoreNum); %?????????????
% else
% disp('Already initialized'); %???????????
% end
% matlabpool close