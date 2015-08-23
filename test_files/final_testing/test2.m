% Test 3
% Reproduce results from IFAC2014_Ex3
addpath('../toolbox')
s=tf('s');

clear p G W w phi per

G(1,1)=2/(s-2);%nominal system
Pnom=G;
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
    inG{i}{1}=tf(num,F{i});
    inG{i}{2}=tf(dem,F{i});
end
inG{2}{1}=inG{2}{1}*exp(-0.04*s);% p2 has time delay

desBW=4.5;
W{1}=tf(makeweight(500,desBW,0.33));
NF=(10*desBW)/20;
DF=(10*desBW)*50;
W{2}=tf([1/NF^2 2*0.707/NF 1], [1/DF^2 2*0.707/DF 1]);
W{2}=W{2}/abs(freqresp(W{2},10*desBW));

xi=20; % kexi of laguerre
n=6; % number of basis functions

fs=tf(1);

w=[logspace(-2,3,200)]; %frequency points
nq=25; % %number of griding point of theta


g_max=2;
g_min=.7;
g_tol=1e-2;

opts = condesopt('nq',nq,'w',w,'gamma',[g_min,g_max,g_tol]);
phi = conphi('lag',[xi n],'s',[],'tf');
per = conper('Hinf',W);
tic
[K,sol] = condes(inG,phi,per,opts);
toc