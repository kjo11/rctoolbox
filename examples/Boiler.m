load('step_response_boiler.mat')

clear G

s=tf('s');

T3=(resp_3L.time(2)-resp_3L.time(1))*60;
T3=1;
u3=resp_3L.u(701:1300)';
y3=resp_3L.y(701:1300)./10;
z3=iddata(y3,u3,T3)

M3=pem(z3,'P1D');

Kp=M3.Kp.value;Td=M3.Td.value;Tp=M3.Tp1.value;
G{6}=Kp*exp(-Td*s)/(Tp*s+1)




T4=(resp_4L.time(2)-resp_4L.time(1))*60;
T4=1;
u4=resp_4L.u;
y4=resp_4L.y./10;
z4=iddata(y4,u4,T4)
plot(z4)

M4=pem(z4,'P1D');

Kp=M4.Kp.value;Td=M4.Td.value;Tp=M4.Tp1.value;
G{5}=Kp*exp(-Td*s)/(Tp*s+1)



T5=(resp_5L.time(2)-resp_5L.time(1))*60;
u5=resp_5L.u(1:2300);
y5=resp_5L.y(1:2300)./10;
z5=iddata(y5,u5,T5)
plot(z5)

M5=pem(z5,'P1D');

Kp=M5.Kp.value;Td=M5.Td.value;Tp=M5.Tp1.value;
G{4}=Kp*exp(-Td*s)/(Tp*s+1)


T6=(resp_6L.time(2)-resp_6L.time(1))*60;
u6=resp_6L.u(1:3500);
y6=resp_6L.y(1:3500)./10;
z6=iddata(y6,u6,T6)
plot(z6)

M6=pem(z6,'P1D');

Kp=M6.Kp.value;Td=M6.Td.value;Tp=M6.Tp1.value;
G{3}=Kp*exp(-Td*s)/(Tp*s+1)

T7=(resp_7L.time(2)-resp_7L.time(1))*60;
u7=resp_7L.u;
y7=resp_7L.y./10;
z7=iddata(y7,u7,T7)
plot(z7)

M7=pem(z7,'P1D');
Kp=M7.Kp.value;Td=M7.Td.value;Tp=M7.Tp1.value;
G{2}=Kp*exp(-Td*s)/(Tp*s+1)


T8=(resp_8L.time(2)-resp_8L.time(1))*60;
u8=resp_8L.u;
y8=resp_8L.y./10;
z8=iddata(y8,u8,T8)
plot(z8)

M8=pem(z8,'P1D');
Kp=M8.Kp.value;Td=M8.Td.value;Tp=M8.Tp1.value;
G{1}=Kp*exp(-Td*s)/(Tp*s+1)

%%
phi=conphi('PI');
per=conper('GPhC',[2,60]);

K=condes(G,phi,per)

% Optimization terminated.
%  
% Transfer function:
% 108.6 s + 1.549
% ---------------
%        s
% 
% %K=(108.6*s+1.549)/s;
%%


%%
r=[zeros(1,10) 5*ones(1,290)];
figure;

subplot(211);hold on
t=0:299;
plot(t,r+20)
title('Step response')
y=zeros(6,300);
u=zeros(6,300);
for i=1:6,
y(i,:)=lsim(K*G{i}/(1+K*G{i}),r,t);
u(i,:)=lsim(K/(1+K*G{i}),r,t);
end
plot(t,y+20)
grid
ylabel('Temperature [C]')
xlabel('Time [s]')
axis([0 300 19 26])
subplot(212);
plot(t,u+1000)
grid
ylabel('Fan speed [rpm]')
xlabel('Time [s]')
%%


% The program for Gain-Scheduled controller design should be run

%load gsController

r=[zeros(1,10) 5*ones(1,290)];
figure;

subplot(211);hold on
t=0:299;
plot(t,r+20)
title('Step response')
y=zeros(6,300);
u=zeros(6,300);

y(1,:)=lsim(K{6}*G{6}/(1+K{6}*G{6}),r,t);
u(1,:)=lsim(K{6}/(1+K{6}*G{6}),r,t);

y(2,:)=lsim(K1*G{6}/(1+K1*G{6}),r,t);
u(2,:)=lsim(K1/(1+K1*G{6}),r,t);

plot(t,y+20)
grid
ylabel('Temperature [C]')
xlabel('Time [s]')
axis([0 300 19 26])
subplot(212);
plot(t,u+1000)
grid
ylabel('Fan speed [rpm]')
xlabel('Time [s]')
%%



% load -ascii data_4_65.tex
% 
% Ti=25;
% Tf=300;
% 
% Tcl_4=data_4_65(Ti:Tf,1)*60;
% Ucl_4=data_4_65(Ti:Tf,2);
% Ycl_4=data_4_65(Ti:Tf,4);
% 
% load -ascii data_8_65.tex
% 
% Tcl_8=data_8_65(Ti:Tf,1)*60;
% Ucl_8=data_8_65(Ti:Tf,2);
% Ycl_8=data_8_65(Ti:Tf,4);
% 
% 
% [Ysim_4,Tsim_4]=step(K*G{5}/(1+K*G{5}),Tf);
% [Ysim_8,Tsim_8]=step(K*G{1}/(1+K*G{1}),Tf);
% 
% figure; hold on
% plot(Tcl_4-24,Ycl_4,Tsim_4,Ysim_4*43+17)
% 
% plot(Tcl_8-24,Ycl_8,Tsim_8,Ysim_8*45+15)
% 
% hold off



