%% Constants
nq=20;
realtol=10e-8;

n=4;% order
xi=0;% Pole

s=tf('s');

%% Model and options
G=(s+10)/((s+2)*(s+4));

w=logspace(-3,3,100);

W{1}=2/(20*s+1)^2;
W{2}=0.8*(1.1337*s^2+6.8857*s+9)/((s+1)*(s+10));
W{3}=tf(0.05);

g_max=1; g_min=0.5; g_tol = 0.01;

phi = conphi('lag',[2 n],'s',1/s,'tf');


opts = condesopt('nq',nq,'TFtol',realtol,'w',w,'lambda',[1 0 0 0]);
per = conper('Hinf',W,1/s);
[K,sol] = condes(G,phi,per,opts);