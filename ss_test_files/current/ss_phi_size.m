addpath('../../toolbox');
s = tf('s');
per = conper('LS',0.3,5/s);

%% correct dimensions
B = [1 0; 1 2];
C = [1, 1; 2, 0];
phi1 = conphi('pid',[0.12],'s',[],'ss',{'B',B});
phi2 = conphi('pid',[0.12],'s',[],'ss',{'C',C});

G1 = [2/(s+0.5); 1];
G2 = transpose(G1);

condes(G1,phi1,per);
condes(G2,phi2,per);

%% incorrect dimensions
B = [1 0 0; 1 2 3];
C = [1, 1; 2, 0; 3 1];
phi1 = conphi('pid',[0.12],'s',[],'ss',{'B',B});
phi2 = conphi('pid',[0.12],'s',[],'ss',{'C',C});

G1 = [2/(s+0.5); 1];
G2 = transpose(G1);

condes(G1,phi1,per);
%%
condes(G2,phi2,per);
