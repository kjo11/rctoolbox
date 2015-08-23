% Test 1: Errors with TF

addpath('../toolbox')
s = tf('s');

%% rational with loopshaping -- error
phi = conphi('gener',[0.2 6],'s',1/s,'tf');

per = conper('LS',0.4,[]);

G = 1/(s+2);

K = condes(G,phi,per)


%% rational with GPhC -- error
phi = conphi('gener',[0.2 6],'s',1/s,'tf');

per = conper('GPhC',[2 45 2]);

G = 1/(s+2);

K = condes(G,phi,per)

%% rational with Hinf, no gamma -- error
phi = conphi('gener',[0.2 6],'s',1/s,'tf');

per = conper('Hinf',tf(0.04));

G = 1/(s+2);

K = condes(G,phi,per)

%% rational with MIMO -- error
phi = conphi('gener',[0.2 6],'s',1/s,'tf');

per = conper('Hinf',tf(0.03),4/s);

G = [1/(s+2); 1];

K = condes(G,phi,per)

%% non-rational with Hinf and no Ld -- error
phi = conphi('gener',[0.2 6],'s',1/s,'lp');

per = conper('Hinf',[2 45 2]);

G = 1/(s+2);

K = condes(G,phi,per)

%% phi and per as cells
phi = conphi('gener',[0.2 6],'s',1/s,'lp');

per = {conper('Hinf',[2 45 2],5/s);};

G = [1/(s+2);1];

K = condes(G,{phi},{per})


%% phi and per as cells
phi = conphi('gener',[0.2 6],'s',1/s,'lp');

per = {conper('Hinf',[2 45 2],5/s);};

G = [1/(s+2);1];

K = condes(G,{phi},per)


