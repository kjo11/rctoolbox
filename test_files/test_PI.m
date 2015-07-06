Ts = 0.01; % sampling time (s)
Gc = tf(0.1034,[0.08791,1]); % continuous time model
Gd = c2d(Gc,Ts); % discrete time model

z = tf('z');
Ki = -100;
Kp = -10;

K = Kp + Ki * z/(z-1);

L = -K*Gd;

figure(1); hold on;
bode(L);