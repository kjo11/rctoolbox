function NyquistConstr(K, inG, per, inw)
%
% NyquistConstr plots the Nyquist diagram of K*G and the constraints
% according to performance specifications in per evaluated at frequency
% vector w
%
%       NyquistConstr(K, G, per, w)
%
%   K :  is the transfer function of the controller designed by CONDES.
%   G :  is the plant model (it may be a cell for multimodel case).
%   per: is the control performance defined by CONPER.
%   w :  is a vector of frequency points in which K*G is evaluated. If w is
%        not given a frequency vector is computed by default using BODE(G).
%        
%
%


m=length(inG);

if ~iscell(inG)
    G{1}=inG;
else
    G=inG;
end

if (nargin < 4)
    inw=[];
else
    for j=1:m, w{j}=inw;end
end;


theta=0:0.01:2*pi;


figure;
hold on

linestyles = {'-b','-c','-k','-y','-m',':b',':c',':k',':y',':m'};

for j=1:m,
    if isempty(inw),
        [~,~,w{j}]=bode(G{j});
    end
    if strncmp(class(G{j}),'id',2)
        [NG{j}(:,1),~,CovG]=freqresp(G{j},w{j});
    else
        NG{j}(:,1)=freqresp(G{j},w{j});
        CovG=[];
    end
    NK{j}(:,1)=freqresp(K,w{j});
    X=real(NK{j}.*NG{j});
    Y=imag(NK{j}.*NG{j});
    plot(X,Y,linestyles{mod(j,length(linestyles))})
    if ~isempty(CovG)
        for k=1:1:length(w{j})
            KDelta=[];
            for theta1=0:0.1:2*pi
                A=sqrt(5.99)*[1 sqrt(-1)]*sqrtm(squeeze(CovG(1,1,k,:,:)))*[cos(theta1);sin(theta1)];
                KDelta=[KDelta;NK{j}(k)*A];
            end
            
            Xd(:,k)=X(k)+real(KDelta);
            Yd(:,k)=Y(k)+imag(KDelta);           
        end
        plot(Xd,Yd,'r')
    end
end
 

if strcmp(per.PerType,'GPhC')==1
    g_m=per.par(1);
    phi_m=per.par(2);
    beta = 45-phi_m/2;
    x1=-3:0.1:2;
    y1=sind(phi_m)/(g_m*cosd(phi_m)-1)*(g_m*x1+1);
    y2=tand(180-beta)*(x1+1/sind(beta));
  
    if numel(per.par)==2
        plot(x1,y1,'r');
    else
        plot(x1,y1,'r',x1,y2,'r');
    end
    
end

if strcmp(per.PerType,'LS')==1
    M_m=per.par(1);
    Ld=per.Ld;
    x1=M_m*cos(theta)-1;
    y1=M_m*sin(theta);

    plot(x1,y1,'r');
end

x=cos(theta);y=sin(theta);
plot(x,y,'g');

axis([-3 2 -3 2]);axis('equal');
grid
hold off