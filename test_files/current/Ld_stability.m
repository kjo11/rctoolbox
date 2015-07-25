% Debug function check_Ld_stability for Ld and G given as d/c tf

addpath('../../toolbox')
s = tf('s');
z = tf('z',0.01);


%% continuous, stable
G = exp(-3*s)/(s*(s+1));

% Ld = 10*(s+1)/((s^2)*(s-1)); % closed loop unstable
% Ld = 10/s; % poles on stability boundary
% Ld = 1*(s+1)/(s^2*(s-1)); % unstable poles
Ld = (s-1)^3/(s^2*(s+1)); % not strictly proper

per = conper('LS',0.4,Ld);



phi = conphi('Laguerre',[0.5 4],'s',1/s);

K = condes(G,phi,per);

%% continuous, unstable
G = exp(-3*s)/((s-1)*(s-10));

% Ld = 10/s; % unstable poles
Ld = 100*(s+1)*(s+10)/(s*(s-1)*(s-10)); % works

per = conper('LS',0.4,Ld);
phi = conphi('Laguerre',[0.5 4],'s',1/s);
K = condes(G,phi,per);

%% discrete, stable
G = (z-0.1)/(z^3*(z^2+z+0.5));

% Ld = 10/(s-1); % unstable/SB poles
% Ld = 10/(s*(s-1)); % unstable
% Ld = (s-1)^3/(s^2*(s+1)); % not strictly proper
Ld = 10/s; % works

per = conper('LS',0.4,Ld);
phi = conphi('Laguerre',[G.Ts,0.5 4],'z',z/(z-1));
K = condes(G,phi,per);

%% discrete, unstable
G = (z-0.1)/(z^3*(z^2+2*z+0.5));

% Ld = 10/(s-1); % SB poles
% Ld = 10/(s*(s-1)); % unstable
% Ld = (s-1)^3/(s*(s+1)); % not strictly proper
% Ld = 10/s; % unstable poles
Ld = 10*(s+1)/(s*(s-1)); % works

per = conper('LS',0.4,Ld);
phi = conphi('Laguerre',[G.Ts,0.5 4],'z',z/(z-1));
K = condes(G,phi,per);

