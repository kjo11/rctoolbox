addpath('../../toolbox')
clear G W phi per

Ts = 1; n = 4; xi = 0;
s = tf('s');
z = tf('z',Ts);

G = (z-0.186)/(z^3 - 1.116*z^2 + 0.465*z - 0.093);
W{1} = 0.4902 *( z^2 - 1.0431* z + 0.3263)/((z-1)*(z-0.282));

phi = conphi('Laguerre',[Ts xi n],'z',z/(z-1),'TF');
per = conper('Hinf',W);
opts = condesopt('gamma',[0.1 1 1e-3]);

[K,sol] = condes(G,phi,per,opts);