%% define systems
s = tf('s');
Gsiso = ss(1/(s^2+14*s+7.5));
Gmimo = ss([1/(s^2+14*s+7.5), tf(0,1); tf(0,1), 2/(20*s+1)]);

%% conphi with state space option
C = [1 0 0; 1 0 0];
D = 0.1;

Aeigs = [0 -0.5 -0.5];
phiSISO = conphi('SS',{Aeigs,[],D},'s');
% phiMIMO = phiSISO; % to use default C
Aeigs = eig(Gmimo.a);
Aeigs = [0;Aeigs(1:end-1)];
phiMIMO = conphi('SS',{Aeigs,C,D},'s'); % to use user-defined C

%% performance and opts
opts = condesopt('Gbands','off');
per = conper('LS',0.4,5/s);

%% condes
Ksiso = condes(Gsiso,phiSISO,per,opts);
% Kmimo = condes(Gmimo,phiMIMO,per,opts);

%% 
Aeigs = [1, 0];
phiSISO = conphi('ss',Aeigs,'s');
phiSISO.phi