function [] = plot_Hinf_TFcons(rhox,phi,fsf,Mf,Nf,Wf,w,gamma,theta_bar,fs)
Y = rhox(:,1)'*phi;

for i=1:size(theta_bar,2)
    Xcell{i}=rhox(:,i+1)'*phi;
end
% figure; semilogx(1,1); hold on
for i=1:length(Nf)
    X{i} = tf(0);
    for j=1:length(Xcell)
        X{i} = X{i}+Xcell{j}*theta_bar(i,j);
    end
    Xf = squeeze(freqresp(X{i},w{i}));
    Yf = squeeze(freqresp(Y,w{i})).*fsf{i};
%     semilogx(w{i},real(squeeze(Nf{i}).*Xf+Mf{i}.*Yf));
%     semilogx(w{i},1/gamma*abs(Wf{i}(:,1).*Mf{i}.*Yf),'-g');
    figure; loglog(w{i},abs(Wf{i}(:,1).*Mf{i}.*Yf.*fsf{i}./(Xf.*squeeze(Nf{i})+Yf.*Mf{i}.*fsf{i})),w{i},gamma*ones(size(w{i})))
    Sfrd=frd(Mf{i}.*Yf.*fsf{i}./(Xf.*squeeze(Nf{i})+Yf.*Mf{i}.*fsf{i}),w{i});
    figure; bode(Sfrd)
end
% for i=1:length(Xcell)
%     figure; bode(Xcell{i}/Y/fs); title(['K{',num2str(i),'}'])
% end