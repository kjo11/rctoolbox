addpath('../../toolbox')
Ts = 0.02;
z = tf('z',Ts);
phi = conphi('gener',[Ts 0 6],'z',z/(z-1),'tf');

phi
phi.phi