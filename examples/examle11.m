clear all

% Create the uncertain real parameters m1, m2, & k
m1 = ureal('m1',1,'percent',20); 
m2 = ureal('m2',1,'percent',20);
k  = ureal('k',1,'percent',20);

s = zpk('s'); % create the Laplace variable s
G1 = ss(1/s^2)/m1; % Cart 1
G2 = ss(1/s^2)/m2; % Cart 2

% Now build F and P
F = [0;G1]*[1 -1]+[1;-1]*[0,G2]; 
P = lft(F,k) % close the loop with the spring k

C=100*ss((s+1)/(.001*s+1))^3; % LTI controller

m=200;
Parray=usample(P,m);
for i=1:m, 
    G{i}=Parray(:,:,i);
    Ld{i}=G{i}*250*(s+5)^3;
    per{i}=conper('LS',0.65,Ld{i});
end

%%

Ts=0.0005;
phi=conphi('lag',[Ts 0 3],'z');

opt=condesopt('w',linspace(0.001,pi/Ts,5000));
tic
[K,sol]=condes(G,phi,per,opt)
toc
%%
figure(1),hold
m=5;
Ptest=usample(P,m);
for i=1:m
    Gtest=Ptest(:,:,i);
    Gd=c2d(Gtest,Ts);
    T{i}=feedback(K*Gd,1);
    step(T{i},0.1);
end
hold
% 

