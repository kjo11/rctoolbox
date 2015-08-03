% Test 2
% Reproduce results from IFAC2014_Ex2

load data_ex10 %loading time domain I/O data

Ts=0.04;       %Sampling time
z=tf('z',Ts);  
s=tf('s');


Gdata = iddata(y,u,Ts); % FR data with uncertainty
GG= spa(Gdata,200,w{1});


nq=20;
realtol=10e-8;
g_max=5;
g_min=.1;
g_tol=1e-2;
ntheta=20; %number of griding point of theta
w{1}=linspace(10e-4,78.539816339744830,128);% frequency points



n=4;% order
xi=0;% Pole


Wc=tf(1+1/s);%weighted function
W{1}=c2d(Wc,Ts);


opts = condesopt('nq',nq,'ntheta',ntheta,'TFtol',realtol,'w',w,'gamma',[g_min g_max g_tol]);
per = conper('Hinf',W);
phi = conphi('lag',[Ts xi n],'z',[],'tf');
[K,sol] = condes(GG,phi,per,opts);