addpath('../../toolbox')
Ts = 0.02;
z = tf('z',Ts);
phi = conphi('Laguerre',[Ts 0 6],'z',z/(z-1),'lp');