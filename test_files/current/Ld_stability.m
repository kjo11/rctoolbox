s = tf('s');
% Ld =  100*(s-800)^4/(s*(s-200)^8);
Ld = 10*(s+18)^7/(s^3*(s+100)^7);
% Ld = 1/(s^3*(s-1));
Ldfrd = frd(Ld,logspace(-12,12,100000));

G = 1/(s-1*exp(-s));
phi = conphi('PID');

per = {conper('LS',0.4,Ldfrd)};

[n_un,n_bd] = frd_windingno(Ldfrd);

p = pole(Ld);
pcl = pole(feedback(1,Ld));

n_un2 = n_un + sum(real(pcl)>0);
real_n_un = sum(real(p) > 0);
real_n_bd = sum(real(p) == 0);

n_un2 == real_n_un
n_bd == real_n_bd

check_Ld_stability(per,G,phi.phi);