%%

ni = 1;
no = 2;
ns = 1;
Ngs = 2;

ntot = ni*no*(ns+1)*Ngs;
nl = (ns+1)*Ngs;

alpha = 4;

H = 2*ones(ntot,ntot);
H = reshape(H,ntot,nl,no,ni);
H(:,nl-Ngs+1:end,:,:) = H(:,nl-Ngs+1:end,:,:) + 3;
H = reshape(H,ntot,ntot);
H = H';
H = reshape(H,ntot,nl,no,ni);
H(:,nl-Ngs+1:end,:,:) = H(:,nl-Ngs+1:end,:,:) + 4;
H = reshape(H,ntot,ntot);
H = H';

A = ones(alpha,ntot);
A = reshape(A,alpha,nl,no,ni);
A(:,nl-Ngs+1:end,:,:) = A(:,nl-Ngs+1:end,:,:) + 2;
A = reshape(A,alpha,ntot);

f = ones(ntot,1);
f = reshape(f,nl,no,ni);
f(nl-Ngs+1:end,:,:) = f(nl-Ngs+1:end,:,:) + 2;
f = reshape(f,ntot,1);

B_ss = [];

%% H reshape

nl = ntot/no/ni; % number of total parameters per input/output
nbc = nl - Ngs; % number of B/C parameters per input/output

H2 = reshape(H,ntot,nl,no,ni);

Hbc = H2(:,1:nbc,:,:);
Hd = H2(:,nbc+1:end,:,:);

Hd = reshape(Hd,ntot,Ngs*no*ni)';
Hd = reshape(Hd,Ngs*no*ni,nl,no,ni);

Hdd = Hd(:,nbc+1:end,:,:);
Hdd = reshape(Hdd,Ngs*no*ni,Ngs*no*ni)';

% if isempty(B_ss)
%     Hb = sum(Hbc,4);
%     Hb = reshape(Hb,ntot,nbc*no)';
%     Hb = reshape(Hb,nbc*no,nl,no,ni);
% 
%     Hbb = Hb(:,1:nbc,:,:);
%     Hbb = sum(Hbb,4);
%     Hbb = reshape(Hbb,nbc*no,nbc*no)';
% 
%     Hbd = Hb(:,nbc+1:end,:,:);
%     Hbd = reshape(Hbd,nbc*no,Ngs*no*ni)';
% 
%     Hdb = Hd(:,1:nbc,:,:);
%     Hdb = sum(Hdb,4);
%     Hdb = reshape(Hdb,Ngs*no*ni,nbc*no)';
% 
%     Hout = [Hbb, Hdb; Hbd, Hdd];
% else
%     Hc = sum(Hbc,3);
%     Hc = reshape(Hc,ntot,nbc*ni)';
%     Hc = reshape(Hc,nbc*ni,nl,no,ni);
%     
%     Hcc = Hc(:,1:nbc,:,:);
%     Hcc = sum(Hcc,3);
%     Hcc = reshape(Hcc,nbc*ni,nbc*ni)';
%     
%     Hcd = Hc(:,nbc+1:end,:,:);
%     Hcd = reshape(Hcd,nbc*ni,Ngs*no*ni)';
%     
%     Hdc = Hd(:,1:nbc,:,:);
%     Hdc = sum(Hdc,3);
%     Hdc = reshape(Hdc,Ngs*no*ni,nbc*ni)';
%     
%     Hout = [Hcc, Hdc; Hcd, Hdd];
% end   
    
if isempty(B_ss)
    ndim = 4;
    n = no;
else
    ndim = 3;
    n = ni;
end

Hb = sum(Hbc,ndim);
Hb = reshape(Hb,ntot,nbc*n)';
Hb = reshape(Hb,nbc*n,nl,no,ni);

Hbb = Hb(:,1:nbc,:,:);
Hbb = sum(Hbb,ndim);
Hbb = reshape(Hbb,nbc*n,nbc*n)';

Hbd = Hb(:,nbc+1:end,:,:);
Hbd = reshape(Hbd,nbc*n,Ngs*no*ni)';

Hdb = Hd(:,1:nbc,:,:);
Hdb = sum(Hdb,ndim);
Hdb = reshape(Hdb,Ngs*no*ni,nbc*n)';

Hout = [Hbb, Hdb; Hbd, Hdd];


%% A reshape

A2 = reshape(A,alpha,nl,no,ni);

Abc = A2(:,1:nbc,:,:);
Ad = A2(:,nbc+1:end,:,:);

Ad = reshape(Ad,alpha,Ngs*no*ni);

if isempty(B_ss)
    ndim = 4;
    n = no;
else
    ndim = 3;
    n = ni;
end

Ab = sum(Abc,ndim);
Ab = reshape(Ab,alpha,nbc*n);

Aout = [Ab, Ad];

%% f reshape

f2 = reshape(f,1,nl,no,ni);

fb = f2(1,1:nbc,:,:);
fd = f2(1,nbc+1:end,:,:);

fd = reshape(fd,Ngs*no*ni,1);

if isempty(B_ss)
    ndim = 4;
    n = no;
else
    ndim = 3;
    n = ni;
end

fb = sum(fb,ndim);
fb = reshape(fb,nbc*n,1);

fout = [fb; fd]


