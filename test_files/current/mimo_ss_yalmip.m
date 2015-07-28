addpath('../../toolbox');
addpath(genpath('../../../matlab_tools'));
s = tf('s');
z = tf('z');
close all

% Checklist
% size: 2x2, 2x1, 1x2
% per: LS, Hinf, GPhC
% default C, given C, given B
% discrete, continuous
continuous = 1;
nper = 1;
model = 2;

for continuous=1:2
    for nper=1:3
        for model=1:3

switch nper
    case 1
        per = conper('LS',0.3,5/s);
    case 2
        W{1} = 1/(s+1);
        per = conper('hinf',W,1/s);
    case 3
        per = conper('GPhC',[2 45 10],1/s);
end

switch model
    case 1
        G = [2/(s+0.4), 0.001; 2/(s+1), 0.05/(s+2)];
    case 2
        G = [2/(s+1); 0.05/(s+2)];
    case 3
        G = [2/(s+1), 0.05/(s+2)];
end
opts = condesopt('gbands','off','yalmip','on','lambda',[1 0 0 0],'gamma',[0.01 2 0.001]);
opts2 = condesopt('gbands','off','yalmip','off','lambda',[1 0 0 0],'gamma',[0.01 2 0.001]);

Ts = 0.02;


%% PID, default C

if continuous
    phi1 = conphi('pid',0.1,'s',[],'ss');
else
    phi1 = conphi('pid',Ts,'z',[],'ss');
end

K1 = condes(G,phi1,per,opts);
K2 = condes(G,phi1,per,opts2);

figure; bode(K1,K2);

%% PID, given C
if continuous
    phi1 = conphi('pid',0.1,'s',[],'ss',{'c',[7 1]});
else
    phi1 = conphi('pid',Ts,'z',[],'ss',{'c',[7 1]});
end

K1 = condes(G,phi1,per,opts);
K2 = condes(G,phi1,per,opts2);

figure; bode(K1,K2);

%% PID, given B
if continuous
    phi1 = conphi('pid',0.1,'s',[],'ss',{'b',[1 1]'});
else
    phi1 = conphi('pid',Ts,'z',[],'ss',{'b',[1 1]'});
end

K1 = condes(G,phi1,per,opts);
K2 = condes(G,phi1,per,opts2);

figure; bode(K1,K2);

%% Laguerre, default C
if continuous
    phi1 = conphi('Laguerre',[0.1 6],'s',[],'ss');
else
    phi1 = conphi('Laguerre',[Ts 0.1 6],'z',[],'ss');
end


K1 = condes(G,phi1,per,opts);
K2 = condes(G,phi1,per,opts2);

figure; bode(K1,K2);

%% Laguerre, given C
if continuous
    phi1 = conphi('Laguerre',[0.1 5],'s',[],'ss',{'c',[1 2 3 4 5]});
else
    phi1 = conphi('Laguerre',[Ts 0.1 5],'z',[],'ss',{'c',[1 2 3 4 5]});
end


K1 = condes(G,phi1,per,opts);
K2 = condes(G,phi1,per,opts2);

figure; bode(K1,K2);

%% Laguerre, given B
if continuous
    phi1 = conphi('Laguerre',[0.1 5],'s',[],'ss',{'b',[1 2 3 4 5 ]'});
else
    phi1 = conphi('Laguerre',[Ts 0.1 5],'z',[],'ss',{'b',[1 2 3 4 5 ]'});
end


K1 = condes(G,phi2,per,opts);
K2 = condes(G,phi2,per,opts2);

figure; bode(K1,K2);

pause
close all
        end
    end
    
end

