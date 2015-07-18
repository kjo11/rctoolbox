load model_ex9

% G{1}...G{6} are six first order identified models concerning a domestic condensing boiler in
% different water flow rates theta=[8;7;6;5;4;3] lit./min
% The objective is to compute a gain-scheduled PI controller

%
phi=conphi('PI');
per=conper('GPhC',[2,60]);


theta=[8;7;6;5;4;3];

opt=condesopt('np',2,'gs',theta);


K=condes(G,phi,per,opt)

% Optimization terminated.
% 
% K{1}+theta_1 K{2}+theta_2 K{3} + ... +theta_1^2 k{n}+theta_2^2k{n+1}+...
% 
% K{1}=
%  
% Transfer function:
% 150 s - 1.778
% -------------
%       s
%  
% K{2}=
%  
% Transfer function:
% -24.81 s + 0.74
% ---------------
%        s
%  
% K{3}=
%  
% Transfer function:
% 5.308 s + 0.07472
% -----------------
%         s