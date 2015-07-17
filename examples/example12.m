

s=zpk('s');

% Data from Robust Control Toolbox of Matlab

p{1} = tf(2,[1 -2]);
p{2} = p{1}*tf(1,[.06 1]);              % extra lag
%p{3} = p{1}*exp(-0.02*s);
p{3} = p{1}*tf([-.02 1],[.02 1]);       % time delay
p{4} = p{1}*tf(50^2,[1 2*.1*50 50^2]);  % high frequency resonance
p{5} = p{1}*tf(70^2,[1 2*.2*70 70^2]);  % high frequency resonance
p{6} = tf(2.4,[1 -2.2]);                % pole/gain migration
p{7} = tf(1.6,[1 -1.8]); 


desBW = 4.5;
Wperf= makeweight(500,desBW,0.33);

NF = (10*desBW)/20;  % numerator corner frequency
DF = (10*desBW)*50;  % denominator corner frequency
Wnoise = tf([1/NF^2  2*0.707/NF  1],[1/DF^2  2*0.707/DF  1]);
Wnoise = Wnoise/abs(freqresp(Wnoise,10*desBW));


%---------------------------------------------------------------------


Ld=4.5*(s+2)/s/(s-2);

w=logspace(-2,3,1000);

opt=condesopt('w',w,'gamma',[0.1,4,0.001]);
W{1}=Wperf;W{2}=Wnoise;
per=conper('Hinf',W,Ld);

n=9
for n=1:10,
phi=conphi('lag',[100 n],'s',1/s);
%phi=conphi('gen',logspace(-1,2,n),'s',1/s);
[K,sol]=condes(p,phi,per,opt);
gam(n)=sol.gamma;
clear Ld per; 
    for i=1:7;
        Ld{i}=K*p{i};
        per{i}=conper('Hinf',W,Ld{i});
        opt.gamma=[0.1,sol.gamma,0.001];
    end
end  

%figure;hold;for j=1:7, T1=feedback(p{j}*K,1);step(T1,3),end,hold

% K=
%  
% Zero/pole/gain:
% 325.3633 (s+2.154)
% ------------------
%     s (s+100)

%----------------------------------------------------------------------

for i=1:7, 
    T{i}=feedback(K*p{i},1);
    S{i}=1-T{i};
    gamma(i,:)=[norm(W{1}*S{i},'inf') norm(W{2}*T{i},'inf')];
end



%----------------------------------------- Matlab Solution ----------------

Parray = stack(1,p{2},p{3},p{4},p{5},p{6},p{7});
orderWt = 4;
Parrayg = frd(Parray,logspace(-1,3,60));
[P,Info] = ucover(Parrayg,p{1},orderWt,'InputMult');


P.u = 'u';   P.y = 'yp';
Wperf.u = 'd';   Wperf.y = 'Wperf';
Wnoise.u = 'n';  Wnoise.y = 'Wnoise';
S1 = sumblk('e = -ym');
S2 = sumblk('y = yp + Wperf');
S3 = sumblk('ym = y + Wnoise');
G = connect(P,Wperf,Wnoise,S1,S2,S3,{'d','n','u'},{'y','e'});

ny = 1; nu = 1;
[C,CL,muBound] = dksyn(G,ny,nu);

Cr = reduce(C,6);

for i=1:7, 
    T{i}=feedback(C*p{i},1);
    S{i}=1-T{i};
    gamma(i,:)=[norm(W{1}*S{i},'inf') norm(W{2}*T{i},'inf')];
end


