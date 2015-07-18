clear all


% Multimodel, MISO, continuous, PID, 'GPhC'

s=tf('s');
G{1}=[5*exp(-3*s)/(4*s+1) 2.5*exp(-5*s)/(15*s+1)];% 5*exp(-3*s)/(4*s+1); 5*exp(-3*s)/(4*s+1) 2.5*exp(-5*s)/(15*s+1) 5*exp(-3*s)/(4*s+1)];% -4*exp(-6*s)/(20*s+1) exp(-4*s)/(5*s+1)];

    
G{2}=[10*exp(-6*s)/(8*s+1)  5*exp(-10*s)/(30*s+1)];% 5*exp(-3*s)/(4*s+1); 2.5*exp(-5*s)/(15*s+1) 5*exp(-3*s)/(4*s+1) 5*exp(-3*s)/(4*s+1)]; 

phi=conphi('PID'); 

per=conper('GPhC',[3,60],1/(30*s)); 


w=0:0.01:pi;

options = condesopt ('Gbands','on', 'np',1,'gs',[-1;1],'yalmip','off');
K=condes(G,phi,per,options)

% No problems detected 
% 
% K{1}+theta_1 K{2}+theta_2 K{3} + ... +theta_1^2 k{n}+theta_2^2k{n+1}+...
% 
% K{1}=
% 
% ans =
%  
%   From input 1 to output...
%        0.02802 s + 0.001776
%    1:  --------------------
%                 s
%  
%        0.03548 s + 0.005849
%    2:  --------------------
%                 s
%  
%   From input 2 to output...
%        -0.005358 s - 0.003934
%    1:  ----------------------
%                  s
%  
%        0.1392 s + 0.008201
%    2:  -------------------
%                 s
%  
% Continuous-time transfer function.
% 
% K{2}=
% 
% ans =
%  
%   From input 1 to output...
%        -0.001907 s - 0.0005714
%    1:  -----------------------
%                   s
%  
%        -0.005791 s - 0.002216
%    2:  ----------------------
%                  s
%  
%   From input 2 to output...
%        0.00175 s + 0.001436
%    1:  --------------------
%                 s
%  
%        -0.01168 s - 0.002877
%    2:  ---------------------
%                  s
%  
% Continuous-time transfer function.
