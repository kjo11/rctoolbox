load flex_trans.mat
s = tf('s');
z = tf('z');

Ld = 1/(5*s);

n = 10;
Mm = 0.45;
Ku = 1;
wc = 1;

F = z/(z-1);

%% Laguerre - 0
phi = conphi('Laguerre',[G{1}.Ts, 0, n],'z',F);
per = conper('LS',[Mm,Ku,wc],Ld);

K = condes(G,phi,per);
tf(K)

%% Laguerre - 1
phi = conphi('Laguerre',[G{1}.Ts, 0.9, n],'z',F);
per = conper('LS',[Mm,Ku,wc],Ld);

K = condes(G,phi,per);
tf(K)

%% Laguerre - 2
phi = conphi('Laguerre',[G{1}.Ts, 0.6, n],'z',F);
per = conper('LS',[Mm,Ku,wc],Ld);

K = condes(G,phi,per);
tf(K)

%% Generalized
phi=conphi('Generalized',[0.1 0.2 0.3 0.4 0 0.6 0 0 0 0 0 0 0 ],'z',F);
per = conper('LS',[Mm,Ku,wc],Ld);

K = condes(G,phi,per);
tf(K)

%% User-defined
phi=conphi('UD',[z/(z-1); 1/(z-1);1/(z*(z-1));1/(z^2*(z-1));1/(z^3*(z-1));1/(z^4*(z-1));1/(z^5*(z-1));1/(z^6*(z-1));1/(z^7*(z-1))]);
per = conper('LS',[Mm,Ku,wc],Ld);

K = condes(G,phi,per);
tf(K)
