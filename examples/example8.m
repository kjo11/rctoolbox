clear all
addpath('../toolbox')
addpath('../orig_toolbox')

% Multimodel, MIMO, continuous, PI, 'Hinf', 

s=tf('s');
G{1}=[-33.89/((98.02*s+1)*(0.42*s+1)) 32.63/((99.6*s+1)*(0.35*s+1));...
    -18.85/((75.43*s+1)*(0.3*s+1)) 34.84/((110.5*s+1)*(0.03*s+1))];

G{2}=[-33.89*exp(-0.1*s)/((98.01*s+1)*(0.43*s+1)) 32.63*exp(-0.1*s)/((98.5*s+1)*(0.33*s+1));...
    -18.85*exp(-0.1*s)/((76*s+1)*(0.31*s+1)) 34.84*exp(-0.1*s)/((109.5*s+1)*(0.025*s+1))];

 
Ld=1/(10*s); 


W{1}=(s+1000)/(1000*s+1); 
W{2}=(500*s+1000)/(3*s+5000); 
phi=conphi('PID',0.05,'s'); 


per=conper('Hinf',W,Ld); 

[K1, sol1]=condes_orig(G,phi,per);
pause
[K3, sol3] = condes(G,phi,per);
pause
% Optimization terminated.
%  
% Transfer function from input 1 to output...
%       -116.6 s^2 - 445.6 s - 1.011
%  #1:  ----------------------------
%                s^2 + 20 s
%  
%       -5.757 s^2 - 304.8 s - 0.5485
%  #2:  -----------------------------
%                s^2 + 20 s
%  
% Transfer function from input 2 to output...
%       88.15 s^2 + 477.4 s + 0.8162
%  #1:  ----------------------------
%                s^2 + 20 s
%  
%       12.65 s^2 + 495.1 s + 0.8538
%  #2:  ----------------------------
%                s^2 + 20 s
% Continuous-time transfer function.
% 
% 
% sol1 = 
% 
%        rho: [12x1 double]
%          A: [4216x12 double]
%          b: [4216x1 double]
%     optval: 229.3234
%      gamma: []
%      xflag: 1

options=condesopt('gamma',[0.1,2,.1]);
% options = condesopt;

[K2, sol2]=condes_orig(G,phi,per,options);
pause
[K4, sol4]=condes(G,phi,per,options);

% K2 =
%  
%   From input 1 to output...
%        -166 s^2 - 250.7 s - 1.267
%    1:  --------------------------
%                s^2 + 20 s
%  
%        -42.37 s^2 - 126.6 s - 0.6859
%    2:  -----------------------------
%                 s^2 + 20 s
%  
%   From input 2 to output...
%        48.06 s^2 + 322.9 s + 2.206
%    1:  ---------------------------
%                s^2 + 20 s
%  
%        21.31 s^2 + 405.2 s + 1.733
%    2:  ---------------------------
%                s^2 + 20 s
%  
% Continuous-time transfer function.
% 
% 
% sol2 = 
% 
%        rho: [12x1 double]
%          A: [1984x12 double]
%          b: [1984x1 double]
%     optval: 559.4670
%      gamma: 0.8422
%      xflag: 1
