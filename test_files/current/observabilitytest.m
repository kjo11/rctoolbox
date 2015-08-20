ns=4;

Ccell=@(x) {'c',spdiags(ones(min(ns,x)),0,zeros(ns,x))};

for phitype=0:3
    switch phitype
        case 0
            x = 2;
            phi_ss = conphi('pid',0.01,'s',[],'ss',Ccell(x));
            phi = conphi('pid',0.01,'s');
        case 1
            x = 1;
            phi_ss = conphi('pi',[],'s',[],'ss',Ccell(x));
            phi = conphi('pi',[],'s');
        case 2
            x = 5;
            phi_ss = conphi('lag',[2 x-1],'s',1/s,'ss',Ccell(x));
%                     phi_ss.phi(end) = tf(0,1);
            phi = conphi('lag',[2 x-1],'s',1/s);
        case 3
            n = [0.1 0.2 0.3 0.4];
            x = length(n)+1;

            phi_ss = conphi('gen',n,'s',1/s,'ss',Ccell(x));
%                     phi_ss.phi(end) = tf(0,1);
            phi = conphi('gen',n,'s',1/s);
    end   
end
