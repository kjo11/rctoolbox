% Debug function check_Ld_stability for Ld and G given as d/c zpk

addpath('../../toolbox')
s = tf('s');
z = tf('z',0.01);

Gc = 3/(s+1);
Gd = (z-0.1)/(z^3*(z^2+z+0.5));

Ld = 10/s;

phic = conphi('Laguerre',[0.5 4],'s',1/s);
phid = conphi('Laguerre',[Gd.Ts, 0.5, 4],'z',z/(z-1));

%% continuous, zpk
G = zpk(Gc);
% G = Gc;
Ld = zpk(Ld);

per = conper('LS',0.4,Ld);
K = condes(G,phic,per);

%% continuous, ss
G = ss(Gc);
% G = Gc;
Ld = ss(Ld);

per = conper('LS',0.4,Ld);
K = condes(G,phic,per);

%% discrete, zpk
G = zpk(Gd);
% G = Gd;
Ld = zpk(Ld);

per = conper('LS',0.4,Ld);
K = condes(G,phid,per);

%% discrete, ss
G = ss(Gd);
% G = Gd;
Ld = ss(Ld);

per = conper('LS',0.4,Ld);
K = condes(G,phid,per);
