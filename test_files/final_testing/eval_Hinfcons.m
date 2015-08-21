function [] = eval_Hinfcons(G,K,W,lambda,gamma,w,theta,np,H)

if ~iscell(G)
    G = {G};
end
if ~iscell(w)
    w2=cell(1,length(G));
    w2(1,:)={w};
    w=w2;
end
if length(W)<4
    W(length(W)+1:4) = {tf(0)};
end

for i=1:length(G)
    n=1;
    if iscell(K)
        K2=K{1};
        for j=1:max(np)
            for k=1:size(theta,2)
                if np(k)<j
                    continue;
                end
                n = n+1;
                K2 = K2 + theta(i,k)^j*K{n};
            end
        end
    else
        K2=K;
    end
    if nargin > 8
        K2 = feedback(K2,H);
    end
    S = feedback(1,K2*G{i});
    T = 1-S;
    U = K2*S;
    V = G{i}*S;
    
    Sfns = {S,T,U,V};

    if sum(lambda)==0
        for k=1:4
            if sum(W{k}.num{1}~=0)
                x = freqresp(W{k}*Sfns{k},w{i});
                if max(max(max(abs(x)))) > gamma
                    error('Constraints violated: k=%i, lambda=0',k)
                end
            end
        end
    else
        x = freqresp(lambda(1)*W{1}*S + lambda(2)*W{2}*T + lambda(3)*W{3}*U + lambda(4)*W{4}*V,w{i});
        if max(max(max(abs(x)))) > gamma
            error('Constraints violated: sum')
        end
        for k=1:4
            if lambda(k)==0 && sum(W{k}.num{1}~=0)
                x = freqresp(W{k}*Sfns{k},w{i});
                if max(max(max(abs(x)))) > 1
                    error('Constraints violated: k=%i, lambda=0',k)
                end
            end
        end

    end
end
disp('All good!')     
end