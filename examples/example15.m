
clear all


gamma = ureal('gamma',2,'Perc',30);  % uncertain gain
tau = ureal('tau',1,'Perc',30);      % uncertain time-constant
wn = 50; xi = 0.25;
P = tf(gamma,[tau 1]) * tf(wn^2,[1 2*xi*wn wn^2]);
desBW = 1;
Wperf = makeweight(500,desBW,0.5);
Wnoise = 0.0025 * tf([25 7 1],[2.5e-5 .007 1]);
W{2}= makeweight(0.1,20,10);
W{1}=Wperf;W{3}=Wnoise;
rng('default')

m=60;
Parray = usample(P,m);
for i=1:m, 
    G{i}=Parray(:,:,i);
end

s=zpk('s');

wc=5;
Ld=wc/s;
per=conper('Hinf',W,Ld);


phi=conphi('gen',logspace(-1,2,3),'s',1/s);



opt=condesopt('gamma',[0.1,5,0.01],'lambda',[1 0 0 0]);
tic
[K,sol]=condes(G,phi,per,opt)
toc

S = feedback(1,Parray*K);  % sensitivity to output disturbance
figure;bodemag(S,'r',{1e-2,1e3}), grid

figure;step(S,8);









% s=zpk('s');
% G=(s-1)/(s+1);
% W{1}=0.1*(s+100)/(100*s+1); W{2}=tf(0.1); W{3}=[];
% P=augw(G,W{1},W{2},W{3});
% [K1,CL1,GAM]=hinfsyn(P);
% % In this case, GAM = 0.1854 = ?14.6386 db
% 
% norm(CL1,'inf')
% 
% m1_RC=squeeze(bode(CL1(1),logspace(-2,5,1000)));
% m2_RC=squeeze(bode(CL1(2),logspace(-2,5,1000)));
% 
% gamma1=max(m1_RC+m2_RC)
% 
% 
% phi=conphi('PID');
% hinfper=conper('Hinf',W,1/s);
% 
% opt=condesopt('gamma',[0.01,1,0.01],'w',logspace(-2,5,1000),'lambda',[1 1 0 0]);
% K2=condes(G,phi,hinfper,opt)
% 
% CL2(1)=W{1}/(1+G*K2);
% CL2(2)=minreal(W{2}*G*K2/(1+G*K2));
% 
% norm(CL2,'inf')
% 
% m1_FD=squeeze(bode(CL2(1),logspace(-2,5,1000)));
% m2_FD=squeeze(bode(CL2(2),logspace(-2,5,1000)));
% 
% gamma2=max(m1_FD+m2_FD)