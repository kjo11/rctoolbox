%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Delete "TAC1.txt" in current folder before running this code
% Modify "num_pole" can define the number of candidate poles
% Modify "max_order" can define the number of higest order of basis
% function
% Edit "xi" can define the values of poles
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
close all;
warning off
num_pole=1; % number of different poles of Laguerre function
max_order=9  % maximum order of basis function
for iter=1:num_pole
for n=1:max_order 
clc
clear phi;
clear phiGq;
Ts=1;
z=tf('z',Ts);

G=(z-0.186)/(z^3-1.116*z^2+0.465*z-0.093);
Pnom=G;
p(1) = Pnom;
Parray=stack(1,p(1));
num_submodel=1;
F=cell(num_submodel,1);
k=[3,1,1,1,1,1];

for i=1:num_submodel
    [num,den]=tfdata(p(i),'v');
    N(i)=p(i);
    M(i)=zpk(1);
end

W(1,1)=0.4902*(z^2-1.0432*z+0.3263)/(z^2-1.282*z+0.282);

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Setup of Controller %%%%%%%%%%%%%%%%%%%%%%%%%%
xi=[0,0.1,0.2,.3,.4,.5];
a=xi(iter); % -1 < a < 1
phi(1,1)=zpk(1);
for j=2:n+1
    phi(j,1)=sqrt(1-a^2)/(z-a)*((1-a*z)/(z-a))^(j-2);
end
fs=(z-1)/(z);% inverse of integrater
%fs=tf(1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nq=20;%number of griding point of theta
w{1}=linspace(0,pi,50);% frequency point
phif=freqresp(phi,w{1});% num_basis*1*frequencypoint
Gf=freqresp(p,w{1});
Nf=freqresp(N,w{1});%1*num_submodel*frequencypoint
Mf=freqresp(M,w{1});%
Wf=freqresp(W,w{1});%num_weight*1*frequencypoint
fsf=freqresp(fs,w{1});

[num,nr,nc]=size(phif);
f2=[zeros(1,2*num)];

%------------ Bisection algorithm to minimize gamma------------------------
gamma_opt=0;
g_max=1;
g_min=.1;
g_tol=1e-3;
gamma=g_min;
realtol=0.001;
x_opt=0;
%ops = optimset ('Largescale', 'on','MaxIter',1000,'TolFun',1e-8);

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
                    phiGq(j,:)= [squeeze(phif(j-num,1,:).*fsf.*Mf(1,i,:))'+exp(1i*2*pi*q/nq)/cos(q/nq)*squeeze(Wfgamma(1,1,:))'.*squeeze(phif(j-num,1,:).*fsf.*Mf(1,i,:))'];%=
                end
            end
            A1=-real(transpose(phiGq));
            h=size(A1);
            b1=-realtol*ones(h(1),1);
            A = [A ; A1];
            b = [b ; b1];
        end 
    end
    [x,optval,xflag] = linprog(f2,A,b,[],[],[],[],[]);% solving the optimization

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
% myfig=sprintf('%d%d',iter,n);
% figure,[y_output,sim_time]=step(minreal(feedback(Parray*K,1)));
% gcf=plot(sim_time,y_output)
% saveas(gcf,myfig,'fig')

SS=norm(minreal(W(1,1)*feedback(1,K*G)),inf)

fid = fopen('TAC1.txt','at');
fprintf(fid,'%g\t',[a;n+1;g_max;SS]);
fprintf(fid,'\n');
fclose(fid);
% figure;step((feedback(G*K,1)));
% text(0.2,0.5,['gamma=', num2str(g_max) '  SS=',num2str(SS)],'units','normalized');
% saveas(gcf,myfig,'fig');

end
end
TAC1_data=load('TAC1.txt');
 figure;hold on;
 a={'r','g-','b:','k-.','m--','co'};
 for i=1:num_pole
     plot(2:max_order+1,TAC1_data((i-1)*max_order+1:i*max_order,4),a{i})
     hold on;
 end
box on