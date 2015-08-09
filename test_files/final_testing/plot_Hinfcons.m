function [] = plot_Hinfcons(G,K,W,lambda,gamma,w,theta,np)

if ~iscell(G)
    G = {G};
end
if ~iscell(w)
    w2=cell(1,length(G));
    w2(1,:)={w};
    w=w2;
end
figure(1); figure(2); figure(3); figure(4);
hold all
for i=1:length(G)
    if iscell(K)
        K2=K{1};
        for j=1:size(theta,2)
            for k=1:np(j)
                K2 = K2 + theta(i,j)*K{j+1}^(k);
            end
        end
    else
        K2=K;
    end
    S = feedback(1,K2*G{i});
    T = 1-S;
    U = K2*S;


    if sum(lambda)==0
        figure(1); bode(W{i}*S,tf(gamma),w{i})
        figure(2); bode(W{2}*T,tf(gamma),w{i})
        figure(3); bode(W{3}*U,tf(gamma),w{i})
    else
        figure(1); bode(lambda(1)*W{i}*S + lambda(2)*W{2}*T + lambda(3)*W{3}*U,tf(gamma),w{i})
        if lambda(1)==0
            figure(2); bode(W{i}*S,tf(1),w{i})
        end
        if lambda(2)==0
            figure(3); bode(W{2}*T,tf(1),w{i})
        end
        if lambda(3)==0
            figure(4); bode(W{3}*U,tf(1),w{i})
        end
    end
end
            
end