%% Test condes with negative plant models for PID controllers with no Ld
close all

%% Models
s=tf('s');
z=tf('z');
Ts = 0.02; % sampling time (s)
G{1} = tf(0.1034,[0.08791,1]); % continuous time model
G{2} = (s-10)/((s+10)*(s+5));
G{3} = (s-9.9)/((s+10.1)*(s+5));
G{4} = -100/(0.09*s+1);

% Gd{5} = (33.23*z^5 - 63.31*z^4 + 15.36*z^3 + 58.43*z^2 - 61.2*z + 17.49)/(z^6 - 4.482*z^5 + 8.948*z^4 - 10.2*z^3 + 6.951*z^2 - 2.648*z + 0.4273);
% Gd{5}.Ts = 0.02;
% Gnd{5} = -Gd{5};
% G{5} = d2c(Gd{4});


for i=1:length(G)
    Gd{i} = c2d(G{i},Ts); % discrete time model
    Gn{i} = -G{i};
    Gnd{i} = -Gd{i};
end



%% Constraints
g_m = 4;
phi_m = 45;
wc = 1;

%% Phi and performance
phi{1}{1} = conphi('PI');
phi{2}{1} = conphi('PID');
phi{3}{1} = conphi('PD');
phi{4}{1} = conphi('P');

phi{1}{2} = conphi('PI',Ts,'z^-1');
phi{2}{2} = conphi('PID',Ts,'z^-1');
phi{3}{2} = conphi('PD',Ts,'z^-1');
phi{4}{2} = conphi('P',Ts,'z^-1');

per{1} = conper('GPhC', [g_m, phi_m, wc]);
per{2} = conper('GPhC', [g_m, phi_m]);


%% Controllers
modelnum = [1,4];
continuous = 2;
ktype = 2; % 1: PI, 2: PID, 3: PD, 4: P
ptype = 2; % 1: GPhC, 2: GPh

if continuous == 1
    Gpos = G(modelnum);
    Gneg = Gn(modelnum);
else
    Gpos = Gd(modelnum);
    Gneg = Gnd(modelnum);
end
        

K1p = condes(Gpos,phi{ktype}{continuous},per{ptype});
K1n = condes(Gneg,phi{ktype}{continuous},per{ptype});


figure;
step(feedback(K1p*Gpos{1},1),feedback(K1n*Gneg{1},1))

NyquistConstr(K1p,Gpos{1},per{ptype})
NyquistConstr(K1n,Gneg{1},per{ptype})
