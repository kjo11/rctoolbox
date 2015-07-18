clear all


% Multimodel, MIMO, continuous, PI, 'Hinf', 

s=tf('s');
G{1}=[5*exp(-3*s)/(4*s+1) 2.5*exp(-5*s)/(15*s+1); -4*exp(-6*s)/(20*s+1) exp(-4*s)/(5*s+1)];

    
G{2}=[10*exp(-6*s)/(8*s+1)  5*exp(-10*s)/(30*s+1); -8*exp(-12*s)/(40*s+1) 2*exp(-8*s)/(10*s+1)];

% G = [1/(4*s+1), 0; 0, 1/(10*s+1)];

W{1}=tf(0.5);
W{2}=0.5*(2*s+1)/(s+1);

phiPI=conphi('PI'); 

phiSS = conphi('SS',{[0,-0.5,0,-0.3],[1 0 0 0; 0 1 0 0]});

% phiSS = conphi('UD',[zpk(0,[0,-0.9],1); zpk([],[0,-0.9],1)]);

% per=conper('Hinf',W,1/(30*s)); 
per = conper('LS',0.001,1/(s));


% options = condesopt ('lambda',[1 1 0 0]);
options = condesopt;

%options = condesopt ('lambda',[1 1 0 0],'gamma',[0.5,2,0.01]);

[KPI,sol]=condes(G,phiPI,per,options);
[Kss,sol2] = condes(G,phiSS,per,options);


% No problems detected 
% 
% K =
%  
%   From input 1 to output...
%        0.02729 s + 0.001429
%    1:  --------------------
%                 s
%  
%        0.03634 s + 0.004758
%    2:  --------------------
%                 s
%  
%   From input 2 to output...
%        -0.008702 s - 0.002802
%    1:  ----------------------
%                  s
%  
%        0.1437 s + 0.005965
%    2:  ------------------
%                s
%  
% Continuous-time transfer function.
% 
% 
% sol = 
% 
%        rho: [8x1 double]
%          A: [3480x8 double]
%          b: [3480x1 double]
%     optval: [1x1 struct]
%      gamma: []
%      xflag: 0