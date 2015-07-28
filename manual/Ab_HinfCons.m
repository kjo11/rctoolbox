function [ A b HinfConstraint] = Ab_HinfCons(phiGfreq,Wf,Ldf,nq,lambda,rho)


a(:,1)=real(Ldf)+1;
a(:,2)=imag(Ldf);
A=[];
b=[];
HinfConstraint=[];
[n,m]=size(phiGfreq);

if max(lambda)>0
    
    d=-a(:,1)+(abs(lambda(1)*Wf(:,1))+abs(lambda(2)*Wf(:,4))).*abs(Ldf+1);
    
    if ~isempty(nq)
        for q=1:nq
            for j=1:n
                phiGq(j,:)=phiGfreq(j,:).*(1+(abs(lambda(2)*Wf(:,2))+abs(lambda(3)*Wf(:,3)))*exp(i*2*pi*nq/q)/cos(pi/q))';
            end
            [A1 b1]= Ab_construct (phiGq , a , d);  % right side of the line a(w).x = d(w)
            A = [A ; A1];
            b = [b ; b1];
        end
    else
        L=transpose(phiGfreq)*rho;
        for j=1:m
            HinfConstraint=HinfConstraint+set((abs(lambda(1)*Wf(j,1))+abs(lambda(4)*Wf(j,4))+abs(lambda(2)*Wf(j,2)*L(j))...
                +abs(lambda(3)*Wf(j,3)*L{j}))*(1+Ldf(j))-real((1+conj(Ldf(j)))*(1+L(j)))<0);
        end
    end
    
end


if max(Wf(:,1))~=0 & lambda(1)==0
    
    d=-a(:,1)+abs(Wf(:,1)).*abs(Ldf+1);
    
    
    [A1 b1]= Ab_construct (phiGfreq , a , d);  % right side of the line a(w).x = d(w)
    A = [A ; A1];
    b = [b ; b1];
    
end


if max(Wf(:,2))~=0  & lambda(2)==0
    
    if ~isempty(nq)
        for q=1:nq
            for j=1:n
                phiGq(j,:)=phiGfreq(j,:).*(1+abs(Wf(:,2))*exp(i*2*pi*nq/q)/cos(pi/q))';
            end
            [A1 b1]= Ab_construct (phiGq , a , -a(:,1));  % right side of the line a(w).x = d(w)
            A = [A ; A1];
            b = [b ; b1];
        end
    else
        L=transpose(phiGfreq)*rho;
        for j=1:m,
            HinfConstraint=HinfConstraint+set(abs(Wf(j,2)*L(j)*(1+Ldf(j)))-real((1+conj(Ldf(j)))*(1+L(j)))<0);
        end
    end
end



if max(Wf(:,3))~=0 & lambda(3)==0
    
    if ~isempty(nq)
        for q=1:nq
            for j=1:n
                phiGq(j,:)=phiGfreq(j,:).*(1+abs(Wf(:,3))*exp(i*2*pi*nq/q)/cos(pi/q))';
            end
            [A1 b1]= Ab_construct (phiGq , a , -a(:,1));  % right side of the line a(w).x = d(w)
            A = [A ; A1];
            b = [b ; b1];
        end
    else
        L=transpose(phiGfreq)*rho;
        for j=1:m
            HinfConstraint=HinfConstraint+set(abs(Wf(j,3)*L(j)*(1+Ldf(j)))-real((1+conj(Ldf(j)))*(1+L(j)))<0);
        end
    end
    
end

if max(Wf(:,4))~=0 & lambda(4)==0
    
    
    d=-a(:,1)+abs(Wf(:,4)).*abs(Ldf+1);
    
    [A1 b1]= Ab_construct (phiGfreq , a , d);  % right side of the line a(w).x = d(w)
    A = [A ; A1];
    b = [b ; b1];
end

end

