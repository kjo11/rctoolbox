clear all


% MIMO, continuous, PI, 'Hinf', 

s=tf('s');
G=5*exp(-3*s)/(4*s+1);

[~,~,w] = bode(G);

w2 = logspace(min(w),max(w),length(w)*2);

W{1}=frd(tf(0.5),w);
W{2}=frd(0.5*(2*s+1)/(s+1),w2);

phi=conphi('PI'); 

per=conper('Hinf',W,1/(30*s)); 


options = condesopt ('lambda',[1 1 0 0]);

[K,sol]=condes(G,phi,per,options)


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