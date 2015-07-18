
Ts=1;
z=tf('z',Ts);
s=tf('s');

a=-0.2;b=-1.2;c=0.5;d=-0.1;
j=1;
for a1=[0.93*a 1.07*a]
    for b1=[0.93*b 1.07*b]
        for c1=[0.93*c 1.07*c]
            for d1=[0.93*d 1.07*d]
                G{j}=(z+a1)/(z^3+b1*z^2+c1*z+d1);
                j=j+1;
            end
        end
    end
end

W{1}=0.4902*(z^2-1.0432*z+0.3263)/(z^2-1.282*z+0.282);

Ld=0.2/s;

phi=conphi('Laguerre',[Ts 0 20],'z',z/(z-1))

per=conper('Hinf',W,Ld);

opt=condesopt('gamma',[0.1,1,0.01],'lambda',[1 0 0 0],'w',[0.01:.01:pi])

K=condes(G,phi,per,opt);

figure; hold
for j=1:16
    T{j}=feedback(G{j}*K,1);
    [y t]=step(T{j},30);
    plot(t,y)
end
hold