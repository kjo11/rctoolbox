% Test 1
% Continuous, unstable
% Example 5


disp('Continuous, unstable')

s=tf('s');
G=(s+1)*(s+10)/((s+2)*(s+4)*(s-1));

Ld=2*(s+1)/s/(s-1);

W{1}=2/(20*s+1)^2;
W{2}=0.8*(1.1337*s^2+6.8857*s+9)/((s+1)*(s+10));
W{3}=tf(0.05);

phi=conphi('Laguerre',[20 6],'s',1/s);
phi_tf=conphi('Laguerre',[20 6],'s',1/s,'tf');

per=conper('Hinf',W,Ld);
opt=condesopt('gamma',[0.2 1.8 0.001],'lambda',[1 1 0 0],'nq',30);

[K,sol] = condes(G,phi,per,opt);
[K_tf,sol_tf] = condes(G,phi_tf,per,opt);

sol.gamma
sol_tf.gamma