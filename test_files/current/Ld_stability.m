s = tf('s');
Ld = 10*(s+1)/((s)*(s-1));
Ldfrd = frd(Ld,logspace(-12,12,100000));

G = 1/(s-1);
G = zpk(G);

Ld = zpk(Ld);
Ld = ss(Ld);
Ld.InputDelay = 0.01;
phi = conphi('Laguerre',[0.5 4],'s',1/s);

per = {conper('LS',0.4,Ld)};

check_Ld_stability(per,G,phi.phi);