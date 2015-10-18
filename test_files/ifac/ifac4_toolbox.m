%% Test to reproduce IFAC example 4 using RCToolbox
clear all
addpath('../../toolbox/');

%% plant models
s=tf('s');
Pnom=2/(s-2);%nominal system
p(1) = Pnom*tf(1,[.06 1]);              % extra lag
p(2) = Pnom*tf([-.02 1],[.02 1]);       % time delay
p(3) = Pnom*tf(50^2,[1 2*.1*50 50^2]);  % high frequency resonance
p(4) = Pnom*tf(70^2,[1 2*.2*70 70^2]);  % high frequency resonance
p(5) = tf(2.4,[1 -2.2]);                % pole/gain migration
p(6) = tf(1.6,[1 -1.8]);                % pole/gain migration
Parray=stack(1,p(1),p(2),p(3),p(4),p(5),p(6));


[~,~,num_submodel]=size(Parray);

F=cell(num_submodel,1);
k=[2 1 3 3 1 1,1];% order of system
for i=1:num_submodel % Create N_i and M_i 
    F{i}=1;
    for m=1:k(i)
        F{i}=conv(F{i},[1 100]);% !!!The  order of the polynomia should equal 
%                                 to the order of the plant.From theorotical view point, 
%                                 it doesnot change the result, but in application it affect the computation
    end
    [num,dem]=tfdata(p(i),'v');
    G{i}{1}=tf(num,F{i});
    G{i}{2}=tf(dem,F{i});
end
G{2}{1}=G{2}{1}*exp(-0.04*s);% p2 has time delay

%% conper
desBW=4.5;
W{1} = (0.33*s + 4.95)/(s+0.01);

NF=(10*desBW)/20;
DF=(10*desBW)*50;
W{2}=tf([1/NF^2 2*0.707/NF 1], [1/DF^2 2*0.707/DF 1]);
W{2}=W{2}/abs(freqresp(W{2},10*desBW));

per = conper('Hinf',W);

%% conphi
xi = 20;
n = 6;
phi = conphi('Lag',[xi n],'s',[],'tf');

%% condesopt
w=logspace(-2,3,200); %frequency points
gamma = [1.4, 1.5, 1e-2];
nq = 25;
lambda = [1 1 0 0];
opts = condesopt('gamma',gamma,'nq',nq,'w',w,'lambda',lambda);

%% condes
[K,sol] = condes(G,phi,per,opts);

