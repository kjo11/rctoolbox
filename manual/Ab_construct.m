function [A , b] = Ab_construct (phiGfreq , a , d)

% phiGfreq is a matrix of n rows and N columns where n is the number of
% basis functions and N is the number of frequency points. In the column i
% the value of phi(jw)*G(jw) for the i-th frequency is stored.
% 
% a is a 1*2 vector and d is a scalar such that ax=d represents a line in 
% the complex plane. Should a and d be a function of frequency, they must 
% be entered as, repectively, an N*2 matrix and an N*1 vector.  

hh=size(a);
if hh(1)==1
    
    A=-a(1)*real(transpose(phiGfreq))-a(2)*imag(transpose(phiGfreq));

    h=size(phiGfreq);
    N1=h(2);
    b=-d*ones(N1,1);

else
    
    [n , ~]=size(phiGfreq);
    
    A=(-a(:,1)*ones(1,n)).*real(transpose(phiGfreq))+(-a(:,2)*ones(1,n)).*imag(transpose(phiGfreq));
    
    b=-d;
    
end