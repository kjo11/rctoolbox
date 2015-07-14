%% Test conphi
Aeigs = -[1 2 3 4];
C = [1 0 0 0; 0 1 0 0];
phi = conphi('SS',{Aeigs,C},'s',tf(1,[1 0]));