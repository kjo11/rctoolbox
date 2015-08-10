function [] = plot_Hinfcons(G,K,W,lambda,gamma,w,theta,np)

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
    S = feedback(1,K2*G{i});
    T = 1-S;
    U = K2*S;
    V = G{i}*S;
    
    Sfns = {S,T,U,V};

    if sum(lambda)==0
        for k=1:4
            figure; bode(W{k}*Sfns{k},tf(gamma),w{i})
        end
    else
        figure; bode(lambda(1)*W{1}*S + lambda(2)*W{2}*T + lambda(3)*W{3}*U + lambda(4)*W{4}*V,tf(gamma),w{i})
        for k=1:4
            if lambda(k)==0
                figure; bode(W{k}*Sfns{k},tf(1),w{i})
            end
        end

    end
end
            
end