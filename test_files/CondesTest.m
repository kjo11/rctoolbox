
s=tf('s');

G{1}=exp(-3*s)*4/(10*s+1); 
G{2}=exp(-5*s)/(s^2+14*s+7.5); 
G{3}=exp(-s)*2/(20*s+1);

Ld=1/(30*s);

%% Test 1
[~,~, wG]=bode(G{1});
Ldfrd=frd(Ld,wG);

phi=conphi('PI'); 

per=cell(1,2);
per{1,1}=conper('LS',0.5,Ldfrd ); 
per{1,2}=conper('LS',0.5,Ld); 
per{1,3}=conper('LS',0.5,Ld); 



K=condes(G,phi,per);
figure; step(feedback(K*G{1},1))


%% Test 2
Ldfrd2=frd(Ld,logspace(1,2,50));

per=cell(1,2);
per{1,1}=conper('LS',0.5,Ldfrd); 
per{1,2}=conper('LS',0.5,Ldfrd2); 
per{1,3}=conper('LS',0.5,Ldfrd2); 

K=condes(G,phi,per)
figure; step(feedback(K*G{1},1))


%% Test 3

per=conper('LS',0.5,Ld); 

F=cell(1,2);
F{1}=frd(3/s,wG);
F{2}=frd(3/s,logspace(1,2,50));
F{3}=frd(3/s,wG);

opt=condesopt('F',F);

K=condes(G,phi,per,opt)
figure; step(feedback(K*G{1},1))


%% Test 4
per=conper('LS',0.5,Ldfrd); 

F2=frd(3/s,wG);

opt=condesopt('F',F2);

K=condes(G,phi,per,opt)
figure; step(feedback(K*G{1},1))

