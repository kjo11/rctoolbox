
clear all

load data_ex10

data=iddata(y,u,Te);

M1=oe(data,[4,4,1]);
G=tf(M1.b,M1.f,Te);

z=tf('z',Te);
phi=conphi('Laguerre',[Te , 0 , 4],'z',z/(z-1));


s=tf('s');
Ld=15/s;

%w=0.1:0.1:pi/Te;
%opt=condesopt('w',w);

per=conper('LS',0.5,Ld);

K1=condes(G,phi,per)

T1=feedback(G*K1,1);

M2=spafdr(data);
K2=condes(M2,phi,per)
T2=feedback(G*K2,1);

step(T1,T2)


% Optimization terminated.
% 
% K1 =
%  
%   12.76 z^4 - 43.85 z^3 + 60.09 z^2 - 39.04 z + 10.22
%   ---------------------------------------------------
%                        z^4 - z^3
%  
% Sample time: 0.04 seconds
% Discrete-time transfer function.
% 
% Exiting: the constraints are overly stringent;
%  no feasible starting point found.
% 
% K2 =
%  
%   14.69 z^4 - 51.69 z^3 + 71.77 z^2 - 46.71 z + 12.07
%   ---------------------------------------------------
%                        z^4 - z^3
%  
% Sample time: 0.04 seconds
% Discrete-time transfer function.

% Although we have the message that no feasible point has been found for
% the linearized constraints, the resulting controller does satisfy the
% desired non convex constraint! (because of the conservatism in the
% linearization).


M2=spa(data,100);
W{1}=tf(0.5);
per=conper('Hinf',W,Ld);
K2=condes(M2,phi,per)
T2=feedback(G*K2,1);
figure; step(T2)