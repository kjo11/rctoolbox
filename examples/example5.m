clear all
addpath('../toolbox/');
addpath('../orig_toolbox/');

s=tf('s');

G=(s+1)*(s+10)/((s+2)*(s+4)*(s-1));

Ld=2*(s+1)/s/(s-1);

W{1}=2/(20*s+1)^2;
W{2}=0.8*(1.1337*s^2+6.8857*s+9)/((s+1)*(s+10));
W{3}=tf(0.05);

phi=conphi('PID',0.01);

hinfper=conper('Hinf',W,Ld);


opt=condesopt('gamma',[0.2 1.8 0.001],'lambda',[1 1 0 0],'nq',30);



tic
[K sol]=condes(G,phi,hinfper,opt);
toc

pause

tic
[K2 sol2] = condes_orig(G,phi,hinfper,opt);
toc
% 
% Optimization terminated.
% gamma=0.72891
% 
% K =
%  
%   20.02 s^2 + 368.7 s + 764
%   -------------------------
%          s^2 + 100 s
%  
% Continuous-time transfer function.
% 
% 
% sol = 
% 
%        rho: [3x1 double]
%          A: [3120x3 double]
%          b: [3120x1 double]
%     optval: 46.1707
%      gamma: 0.7289
%      xflag: 1
% 
% Elapsed time is 3.554503 seconds.

opt.nq=[];
opt.yalmip='on';


% tic
% [K3 sol3]=condes(G,phi,hinfper,opt)
% toc


% tic
% [K4 sol4]=condes_orig(G,phi,hinfper,opt)
% toc

% No problems detected 
% gamma=0.72578
% 
% K =
%  
%   20.13 s^2 + 325.6 s + 664.9
%   ---------------------------
%           s^2 + 100 s
%  
% Continuous-time transfer function.
% 
% 
% sol = 
% 
%        rho: [3x1 double]
%          A: []
%          b: []
%     optval: [1x1 struct]
%      gamma: 0.7258
%      xflag: 1
% 
% Elapsed time is 86.754084 seconds.