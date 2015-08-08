function [] = plot_Hinfcons(G,K,W,lambda,gamma,w,theta)

if ~iscell(G)
    G = {G};
end
figure(1); figure(2); figure(3); figure(4);
hold all
for i=1:length(G)
    if iscell(K)
        K2=K{1};
        for j=1:size(theta,2)
            K2 = K2 + theta(i,j)*K{j+1};
        end
    else
        K2=K;
    end
    S = feedback(1,K2*G);
    T = 1-S;
    U = K*S;


    if sum(lambda)==0
        figure(1); bode(W{1}*S,tf(gamma),w{1})
        figure(2); bode(W{2}*T,tf(gamma),w{1})
        figure(3); bode(W{3}*U,tf(gamma),w{1})
    else
        figure(1); bode(lambda(1)*W{1}*S + lambda(2)*W{2}*T + lambda(3)*W{3}*U,tf(gamma),w{1})
        if lambda(1)==0
            figure(2); bode(W{1}*S,tf(1),w{1})
        end
        if lambda(2)==0
            figure(3); bode(W{2}*T,tf(1),w{1})
        end
        if lambda(3)==0
            figure(4); bode(W{3}*U,tf(1),w{1})
        end
    end
end
            
end