%% Script to test function to reduce the order of K when using Laguerre basis functions
load flex_trans.mat
s = tf('s');
z = tf('z');

Ld = 1/(5*s);

n = 10;
Mm = 0.45;
Ku = 1;
wc = 1;

F = z/(z-1);
Fc = 1/s;
Gc = d2c(G{1});

per = conper('LS',[Mm,Ku,wc],Ld);


%% Continuous
for n=1:10
    for a=1:0.1:2
        phi = conphi('Laguerre',[a, n],'s',Fc);
        K = condes(Gc,phi,per);
        Ktf = tf(K);
        num = Ktf.num{1};
        if length(num(num~=0)) > n+1
            fprintf('%4.1f %i %i \n',a,n,length(num(num~=0)));
            pause
        end
    end
end


%% Discrete
for n=1:10
    for a=0:0.1:1
        phi = conphi('Laguerre',[G{1}.Ts, a, n],'z',F);
        K = condes(G,phi,per);
        Ktf = tf(K);
        num = Ktf.num{1};
        if length(num(num~=0)) > n+1
            fprintf('%4.1f %i %i \n',a,n,length(num(num~=0)));
            pause
        end
    end
end