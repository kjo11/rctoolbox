function [A , b] = Ab_construct_MIMO (Gf , phif , a , d , w , ws , q1 , n , ntot, theta_bar)

[~,ns]=min(abs(w-ws(1)));

N1=length(ws);

Ngs=length(theta_bar);

[~ , ni]=size(Gf(:,:,1));

X=zeros(ntot,N1);


for i=1:ni
    
    x2=zeros(Ngs*n(i,q1),N1);
    for u=1:n(i,q1)
        
        x1(u,:)=Gf(q1,i,ns:ns+N1-1).*phif{i,q1}(u,1,ns:ns+N1-1);
        x2((u-1)*Ngs+1:u*Ngs,:)=kron(theta_bar',x1(u,:));
        
    end
    
    v=Ngs*(sum(sum(n(1:i-1,:)))+sum(n(i,1:q1-1)));
    X(v+1:v+Ngs*n(i,q1),:)=x2;

    
end

[A , b] = Ab_construct (X , a , d);



