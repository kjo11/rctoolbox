% Script to test reshaping H, A and f matrices for state space

% constants
ni = 4;
no = 4;
ns = 5;
Ngs = 2;

% number constraints
alpha = 20;

% total number variables -- not state space
ntot = ni*no*ns*Ngs;

% total number variables -- state space
nss = no*ns*Ngs;

% initial H, f, A matrices
H = 1:ntot^2;
H = reshape(H,ntot,ntot);
f = (1:ntot)';
A = 1:ntot*alpha;
A = reshape(A,alpha,ntot);


% calculate Hf, Af, ff manually by looping through number of inputs
Hf = zeros(nss);
Af = zeros(alpha,nss);
ff = zeros(nss,1);
for i=1:ni
    for j=1:ni
        Hf = Hf + H((i-1)*nss+1:i*nss,(j-1)*nss+1:j*nss);
    end
    Af = Af + A(:,(i-1)*nss+1:i*nss);
    ff = ff + f((i-1)*nss+1:i*nss);
end

% calculate Hf, Af, ff by using reshape
Af2 = sum(reshape(A,alpha,nss,ni),3);
ff2 = sum(reshape(f,nss,1,ni),3);
Hf2 = sum(reshape(sum(reshape(H,ntot,nss,ni),3)',nss,nss,ni),3)';

% test that both methods give same answer and that the sum of the elements
% is still the same (should output 0 0 0 1 1 1)
fprintf('%i %i %i %i %i %i \n',...
sum(sum(Af2~=Af)),...
sum(sum(ff2~=ff)),...
sum(sum(Hf2~=Hf)),...
sum(sum(Hf))==sum(sum(H)),...
sum(sum(Af))==sum(sum(A)),...
sum(sum(ff))==sum(sum(f)));