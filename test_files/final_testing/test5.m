% Test 5
% Discrete, unstable
% Example 5


disp('Discrete, unstable')
Ts = 0.005;
s = tf('s');
z = tf('z',Ts);

G=c2d((s+1)*(s+10)/((s+2)*(s+4)*(s-1)),Ts);

Ld=2*(s+1)/s/(s-1);

W{1}=2/(20*s+1)^2;
W{2}=0.8*(1.1337*s^2+6.8857*s+9)/((s+1)*(s+10));
W{3}=tf(0.05);

per=conper('Hinf',W,Ld);


for y=1:2
    if y==1
        opt=condesopt('gamma',[0.2 1.8 0.001],'lambda',[1 1 0 0],'nq',30);
    else
        opt=condesopt('gamma',[0.2 1.8 0.001],'lambda',[1 1 0 0],'nq',30,'yalmip','on');
    end
for i=1:4
    switch i
        case 1
            phi=conphi('Laguerre',[Ts 20 6],'z');
            phi_tf=conphi('Laguerre',[Ts 20 6],'z',[],'tf');
        case 2
            phi=conphi('Laguerre',[Ts 20 6],'z',z/(z-1));
            phi_tf=conphi('Laguerre',[Ts 20 6],'z',z/(z-1),'tf');
        case 3
            phi=conphi('generalized',[Ts linspace(10,25,5)],'z');
            phi_tf=conphi('generalized',[Ts linspace(10,25,5)],'z',[],'tf');
        case 4
            phi=conphi('generalized',[Ts linspace(10,25,5)],'z',z/(z-1));
            phi_tf=conphi('generalized',[Ts linspace(10,25,5)],'z',z/(z-1),'tf');
    end
    [K,sol] = condes(G,phi,per,opt);
    [K_tf,sol_tf] = condes(G,phi_tf,per,opt);
    

    sol.gamma
    sol_tf.gamma
    figure; bode(feedback(K*G,1),feedback(K_tf*G,1))
end
end