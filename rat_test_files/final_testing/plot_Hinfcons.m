function [] = plot_Hinfcons(G,K,W,lambda,gamma,w,theta,np)

if ~iscell(G)
    G = {G};
end
if ~iscell(w)
    w2=cell(1,length(G));
    w2(1,:)={w};
    w=w2;
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


    if sum(lambda)==0
        figure; bode(W{1}*S,tf(gamma),w{i})
        figure; bode(W{2}*T,tf(gamma),w{i})
        figure; bode(W{3}*U,tf(gamma),w{i})
    else
        figure; bode(lambda(1)*W{1}*S + lambda(2)*W{2}*T + lambda(3)*W{3}*U,tf(gamma),w{i})
        if lambda(1)==0
            figure; bode(W{1}*S,tf(1),w{i})
        end
        if lambda(2)==0
            figure; bode(W{2}*T,tf(1),w{i})
        end
        if lambda(3)==0
            figure; bode(W{3}*U,tf(1),w{i})
        end
    end
end
            
end