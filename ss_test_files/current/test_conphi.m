addpath('../../toolbox');

% ----------------------------------------------------------------------- %
%                       Continuous PID                                    %
% ----------------------------------------------------------------------- %
%% 
disp('PID, tau=0.02, continuous, default C')
phi = conphi('pid',0.02,'s',[],'ss'); 
phi.phi

%%
disp('PID, tau=0, continuous, default C')
phi = conphi('pid',[],'s',[],'ss');
phi.phi

%%
disp('PI, continuous, default C')
phi = conphi('pi',[],'s',[],'ss');
phi.phi

%%
disp('PD, tau=0.02, continuous, default C')
phi = conphi('pd',0.02,'s',[],'ss');
phi.phi

%%
disp('PD, tau=0, continuous, default C')
phi = conphi('pd',[],'s',[],'ss');
phi.phi

%%
disp('P, continuous, default C')
phi = conphi('p',[],'s',[],'ss');
phi.phi


%%
% ----------------------------------------------------------------------- %
%                       Discrete PID                                      %
% ----------------------------------------------------------------------- %

Ts = 0.02;
%% 
disp('PID, discrete, default C')
phi = conphi('pid',Ts,'z',[],'ss'); 
phi.phi

%%
disp('PI, discrete, default C')
phi = conphi('pi',Ts,'z',[],'ss');
phi.phi

%%
disp('PD, discrete, default C')
phi = conphi('pd',Ts,'z',[],'ss');
phi.phi

%%
disp('P, discrete, default C')
phi = conphi('p',[],'z',[],'ss');
phi.phi


%%
% ----------------------------------------------------------------------- %
%                       Provided C/B (PID)                                %
% ----------------------------------------------------------------------- %

%%
disp('PID, discrete, provided C (SISO)')
phi = conphi('pid',Ts,'z',[],'ss',{'C',[1 1]}); 
phi.phi

%%
disp('PID, discrete, provided C (error)')
phi = conphi('pid',Ts,'z',[],'ss',{'C',[1 1 1]}); 
phi.phi

%%
disp('PID, discrete, provided C (MIMO)')
phi = conphi('pid',Ts,'z',[],'ss',{'C',[1 1; 0 1]}); 
phi{1}.phi
phi{2}.phi

%%
disp('PID, discrete, provided B (SISO)')
phi = conphi('pid',Ts,'z',[],'ss',{'B',[0; 1]}); 
phi.phi

%%
disp('PID, discrete, provided B (error)')
phi = conphi('pid',Ts,'z',[],'ss',{'B',[1 1 1]}); 
phi.phi

%%
disp('PID, discrete, provided B (MIMO)')
phi = conphi('pid',Ts,'z',[],'ss',{'B',[1 1; 0 1]}); 
phi{1}.phi
phi{2}.phi

%%
% ----------------------------------------------------------------------- %
%                       Continuous other                                  %
% ----------------------------------------------------------------------- %
n = 5;
a = 0.4;
s = tf('s');
F = 1/s;
%%
disp('Laguerre, continuous, default C')
phi = conphi('Laguerre',[a,n],'s',F,'ss');
phi.phi

%%
disp('Generalized, continuous, default C')
phi = conphi('Generalized',[0.1 0.2 0.4 0.6 0.3],'s',F,'ss');
phi.phi

%% 
disp('User defined TF, continuous, default C')
phi = conphi('UD',[1/s; s/(s+1); 1/(s+10)],'s',F,'ss');
phi.phi

%%
disp('User defined eigs, continuous, default C')
phi = conphi('UD',[-1 -3],'s',F,'ss');
phi.phi

%%
% ----------------------------------------------------------------------- %
%                       Discrete other                                    %
% ----------------------------------------------------------------------- %
n = 5;
a = 0.4;
Ts = 0.02;
z = tf('z',Ts);
F = z/(z-1);

%%
disp('Laguerre, discrete, default C')
phi = conphi('Laguerre',[Ts,a,n],'z',F,'ss');
phi.phi

%%
disp('Generalized, discrete, default C')
phi = conphi('Generalized',[Ts 0.1 0.2 0.4 0.6 0.3],'z',F,'ss');
phi.phi

%% 
disp('User defined TF, discrete, default C')
phi = conphi('UD',[z/(z-0.5); 1/(z^2+0.2)],'z',F,'ss');
phi.phi

%%
disp('User defined eigs, discrete, default C')
phi = conphi('UD',[Ts -1 -3],'z',F,'ss');
phi.phi


%%
% ----------------------------------------------------------------------- %
%                       Provided B/C (other)                              %
% ----------------------------------------------------------------------- %
n = 5;
a = 0.4;
Ts = 0.02;
z = tf('z',Ts);
F = z/(z-1);

%%
disp('Laguerre, discrete, provided C (SISO)')
phi = conphi('Laguerre',[Ts,a,n],'z',F,'ss',{'c',ones(1,n+1)});
phi.phi

%%
disp('Generalized, discrete, provided C (error)')
phi = conphi('Generalized',[Ts 0.1 0.2 0.4 0.6 0.3],'z',F,'ss',{'C',ones(1,n)});
phi.phi

%% 
disp('User defined TF, discrete, provided C (MIMO)')
phi = conphi('UD',[z/(z-0.5); 1/(z^2+0.2)],'z',F,'ss',{'C',ones(2,4)});
phi{1}.phi
phi{2}.phi

%%
disp('User defined eigs, discrete, provided C (MIMO)')
phi = conphi('UD',[Ts -1 -3],'z',F,'ss',{'C',[1, 0; 2, 1; 0, 1]});
phi{1}.phi
phi{2}.phi
phi{3}.phi

%%
disp('Laguerre, discrete, provided B (SISO)')
phi = conphi('Laguerre',[Ts,a,n],'z',F,'ss',{'b',ones(1,n+1)'});
phi.phi

%%
disp('Generalized, discrete, provided B (error)')
phi = conphi('Generalized',[Ts 0.1 0.2 0.4 0.6 0.3],'z',F,'ss',{'b',ones(1,n)'});
phi.phi

%% 
disp('User defined TF, discrete, provided B (MIMO)')
phi = conphi('UD',[z/(z-0.5); 1/(z^2+0.2)],'z',F,'ss',{'b',ones(2,4)'});
phi{1}.phi
phi{2}.phi

%%
disp('User defined eigs, discrete, provided B (MIMO)')
phi = conphi('UD',[Ts -1 -3],'z',F,'ss',{'b',[1, 0; 2, 1; 0, 1]'});
phi{1}.phi
phi{2}.phi
phi{3}.phi

