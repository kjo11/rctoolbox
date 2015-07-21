%% define systems
s = tf('s');
Gsiso = ss(1/(s^2+14*s+7.5));
Gmimo = ss([1/(s^2+14*s+7.5), tf(0,1); tf(0,1), 2/(20*s+1)]);

%% conphi with state space option
C = [1 0 0; 1 0 0];
D = 0.1;

Aeigs = [0 -0.5 -0.5];
phiD = conphi('SS',{Aeigs,[],D},'s');
phi = conphi('SS',Aeigs,'s');

%% performance and opts
opts = condesopt('Gbands','off');
per = conper('LS',0.4,5/s);
pergpc = conper('GPhC',[2,45,2]);

%% condes
KD = condes(Gsiso,phiD,pergpc,opts);
% K = condes(Gsiso,phi,per,opts);
