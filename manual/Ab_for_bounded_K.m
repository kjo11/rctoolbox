function [A b] = Ab_for_bounded_K (phif, w, Ku, wh, theta_bar)

% Construts matrix A and vector b for constraint A*rho < b when we want to
% limit the real and imaginary part of the controller K(jw)

if wh >= max(w) | Ku <= 0
    A=[]; b=[];
    return
end

[n , ~]=size(phif(:,:,1));
N=length(w);

[~,whn]=min(abs(w-wh));

Ngs=length(theta_bar);


A1=zeros(N-whn+1,Ngs*n); A3=zeros(N-whn+1,Ngs*n);

for u=1:n
    
    toto(u,:)=phif(u,1,:);    
    A1(:,(u-1)*Ngs+1:u*Ngs)=real(kron(theta_bar',toto(u,whn:N))');
    A3(:,(u-1)*Ngs+1:u*Ngs)=imag(kron(theta_bar',toto(u,whn:N))');
   
end
    
A2=-A1;
A4=-A3;

A = [A1 ; A2 ; A3 ; A4];
b= Ku * ones (4*(N-whn+1),1);

