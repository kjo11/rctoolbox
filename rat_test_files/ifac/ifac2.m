%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modify "n_uncertainty" can change the number of uncertainty vertices
% Modify Section of "Setup of Controller" can select the controller 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
warning off

n_uncertainty=20;
% The covariance matrix of the frequency-domain response is
% presented by an ellips in the Nyquist diagram. In this part, the vertices 
% of a nqq-side polygon circumscribing this ellips is computed. The constraints
% will be satisfied for the vertices of the polygon instead for its center.

load data_ex10 %loading time domain I/O data
Ts=0.04;       %Sampling time
z=tf('z',Ts);  

s=tf('s');

Wc=tf(1+1/s);%weighted function
W(1,1)=c2d(Wc,Ts);
%%%%%%%%%%% Setup of controller %%%%%%%%%%%%%%%%%%%%%%%%%
n=4;% order
xi=0;% Pole
phi(1,1)=zpk(1);
for j=2:n+1
    phi(j,1)=sqrt(1-xi^2)/(z-xi)*((1-xi*z)/(z-xi))^(j-2);
end
fs=(z-1)/(z);%inverse of add-on integrater
fs=tf(1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

w{1}=linspace(10e-4,78.539816339744830,128);% frequency points
% [~,num_fre]=size(w{1});  % number of frequency points
% num_submodel=n_uncertainty; %number of verties

Gdata = iddata(y,u,Te); % FR data with uncertainty
GG= spa(Gdata,200,w{1});
[~,num_fre]=size(w{1});  % number of frequency points
num_submodel=n_uncertainty; %number of verties

for i=1:n_uncertainty
    M(i)=zpk(1);
end

nq=20; %number of griding point of theta
phif=freqresp(phi,w{1});% num_basis*1*frequencypoint
[Nf_nominal,~,CovGf]=freqresp(GG,w{1});
Mf=freqresp(M,w{1});%
Wf=freqresp(W,w{1});%num_weight*1*frequencypoint
fsf=freqresp(fs,w{1});

%%%%%%%%%%%%%%%%%%%%%%%%%% frequency response of N_i %%%%%%%%%%
for q=1:n_uncertainty
        x0=real(2.4474./squeeze(Nf_nominal(1,1,:)) * exp(1i*2*pi*q/n_uncertainty)/cos(pi/n_uncertainty));
        y0=imag(2.4474./squeeze(Nf_nominal(1,1,:)) * exp(1i*2*pi*q/n_uncertainty)/cos(pi/n_uncertainty));
        for k=1:num_fre
            Sigma(k,:,:)=sqrtm((squeeze(CovGf(1,1,k,:,:))));%confidence interval
            Pxy(k)=[1 1i]*squeeze(Sigma(k,:,:))*[x0(k);y0(k)];
        end
        Nf(1,q,:)=transpose(squeeze(Nf_nominal(1,1,:))).*(1+Pxy);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[num,nr,nc]=size(phif);
f2=[zeros(1,2*num)];

%------------ Bisection algorithm to minimize gamma------------------------
gamma_opt=0;
realtol=10e-8;
g_max=5;
g_min=.1;
g_tol=1e-2;
gamma=g_max;
x_opt=0;
ops = optimset ('Largescale', 'on','MaxIter',100000,'TolFun',1e-8);

while g_max-g_min > g_tol
    
    A=[];
    b=[];  
    for i=1:num_submodel
    
        Wfgamma =inv(gamma)*Wf;
        for q=1:nq% gridding the theta
            for j=1:2*num
                if j<=num
                    phiGq(j,:)= [squeeze(phif(j,1,:).*Nf(1,i,:))'];% ST SS SU
                else
                    phiGq(j,:)= [squeeze(phif(j-num,1,:).*fsf.*Mf(1,i,:))'-exp(1i*2*pi*q/nq)/cos(pi/nq)*squeeze(Wfgamma(1,1,:))'.*squeeze(phif(j-num,1,:).*fsf.*Mf(1,i,:))'];%=
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

for q=1:n_uncertainty
    SS(q)=norm( (squeeze(Wf)./squeeze(1+Nf(1,q,:).*freqresp(K,w{1}))),inf);
end
S=max(SS)

figure;
plot((squeeze(Nf_nominal(1,1,:))),'k')
hold on; plot([squeeze(Nf(1,:,1:1:end));transpose(squeeze(Nf(1,1,1:1:end)))])
% for oo=1:5:128
% pdecirc(real(Nf_nominal(1,1,oo)),imag(Nf_nominal(1,1,oo)),sqrt(4*squeeze(CovGf(1,1,oo,1,1))));
% end

figure
Kf=frd(K,w{1});
Sf=1/(1+GG*Kf);
bode(Sf,'sd',2)



% M1=oe(Gdata,[4,4,1]);
% G=tf(M1.b,M1.f,Te);
% T2=feedback(G*K,1);
% norm(W(1,1)*feedback(1,K*G));
% figure;
% step(T2)

% figure;
% for i=1:num_submodel
%    hold on;
%    hh=plot(squeeze((freqresp(X,w{1}).*Nf(1,i,:)+freqresp(Y*fs,w{1}).*1)));
% 
%    for q=1:nq
%       hold on; 
%       hh=plot(squeeze((freqresp(X,w{1}).*Nf(1,i,:)+freqresp(Y*fs,w{1}).*1)+exp(1i*2*pi*q/nq)*.5*inv(g_max)*freqresp(Y*fs,w{1})*1)); %SS
%    end
% end


