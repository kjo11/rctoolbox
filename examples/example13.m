
% This example could not be solved straightforwardly. Because our approach
% for multivariable controller design covers only decoupling controller and
% the specification are defined for the diagonal elements.



%%
clear all

% NASA HiMAT model G(s)
ag =[ -2.2567e-02  -3.6617e+01  -1.8897e+01  -3.2090e+01   3.2509e+00  -7.6257e-01; 
       9.2572e-05  -1.8997e+00   9.8312e-01  -7.2562e-04  -1.7080e-01  -4.9652e-03; 
       1.2338e-02   1.1720e+01  -2.6316e+00   8.7582e-04  -3.1604e+01   2.2396e+01; 
       0            0   1.0000e+00            0            0            0; 
       0            0            0            0  -3.0000e+01            0; 
       0            0            0            0            0  -3.0000e+01]; 
bg = [ 0     0; 
       0     0; 
       0     0; 
       0     0; 
       30     0; 
       0    30]; 
cg = [ 0     1     0     0     0     0; 
       0     0     0     1     0     0]; 
dg = [ 0     0; 
       0     0]; 
G=ss(ag,bg,cg,dg);

s=zpk('s'); 

MS=2;AS=.03;WS=5;
W1=(s/MS+WS)/(s+AS*WS);
MT=2;AT=.05;WT=20;
W3=(s+WT/MT)/(AT*s+WT);


% Compute the H-infinity mixed-sensitivity optimal controller K1
[K1,CL1,GAM1]=mixsyn(G,W1,[],W3);
% Next compute and plot the closed-loop system.
% Compute the loop L1, sensitivity S1, and comp sensitivity T1:
L1=G*K1;
I=eye(size(L1));
S1=feedback(I,L1); % S=inv(I+L1);
T1=I-S1;
% Plot the results:
% step response plots
step(T1,1.5);
title('\alpha and \theta command step responses');
% frequency response plots
%figure;
%sigma(I+L1,'--',T1,':',L1,'r--',... W1/GAM1,'k--',GAM1/W3,'k-.',{.1,100});grid
% legend('1/\sigma(S) performance',...
% '\sigma(T) robustness',...
% '\sigma(L) loopshape',...
% '\sigma(W1) performance bound',...
% '\sigma(1/W3) robustness bound');
%%

W{1}=W1;W{2}=W3;

Ld=2*(s^2 + 1.38*s + 0.5377)/((s+0.1)*(s^2 - 1.38*s + 0.5377));

per=conper('Hinf',W,Ld);
phi=conphi('Generalized',logspace(-2,5,5),'s');

%phi=conphi('Laguerre',[0.01,5],'s');

%  per1{1}=conper('Hinf',W,L1(1,1));
%  per1{2}=conper('Hinf',W,L1(2,2));

w=logspace(-2,6,1000);

opt=condesopt('Gbands','on','gamma',[0.1,10,0.01],'w',w);

[K sol]=condes(G,phi,per,opt)


