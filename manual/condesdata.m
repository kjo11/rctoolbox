function [Gf,Gdim,phi,n,phif,per,w,N,SISO,performance,Ldf,LDf] = condesdata(inG,inphi,inper,options)


% Determining number of models
m=length(inG);

if ~isempty(options.gs)
    [rowtheta,coltheta]=size(options.gs);
    delta=options.np;
    if rowtheta~=m, 
         error('The number of rows of the scheduling parameter matrix should be equal to the number of models')
    end
end


if ~iscell(inG)
    G{1}=inG;
else
    G=inG;
end

% Determining frequency responses of models

w=cell(1,m);
Gf=cell(1,m);
wmax=0;
N=zeros(1,m);
% Determinimg the frequency vector for each model
if ~isempty(options.w)
    if ~iscell(options.w)
        for j=1:m
            w{j}=options.w;
        end
    else
        w=options.w;
    end
else        
    for j=1:m
        if strcmp(class(G{j}),'frd')
           w{j}=G{j}.Frequency;
        else    
            [~,~,w{j}]=bode(G{j});
        end      
    end
end
    % Determining the frequency responses 
for j=1:m
    Gf{j}=freqresp(G{j},w{j});
    N(j)=length(w{j}); % lengths of frequency vectors
    wmax=max(wmax,max(w{j}));
end


        
phif=cell(1,m);
per=cell(1,m);

[no ni]=size(G{1});
if no==1 && ni==1
    
    SISO=true;
    
    
    if strcmp(inphi.ConType,'PID') 
    [num,den]=tfdata(inphi.phi(3),'v');
        if den(1)==0,
            den(1)=1.2/wmax; %default value for tau (time constant of the derivator)
            inphi.phi(3)=tf(num,den);
        end
    end

    if strcmp(inphi.ConType,'PD') 
    [num,den]=tfdata(inphi.phi(2),'v');
        if den(1)==0,
            den(1)=1.2/wmax;  %default value for tau (time constant of the derivator)
            inphi.phi(2)=tf(num,den);
        end
    end
      
    
    phi=inphi.phi;
    [n , ~]=size(phi);
    
    
    for j=1:m
        phif{j}=freqresp(phi,w{j});
    end
    
    
    if ~iscell(inper)
        per(1,:)={inper};
    else
        per=inper;
    end
    
    % Determinig frequency response of desired open loop
    LDf=[];
    if isempty(per{1}.Ld)
        Ldf=[]; 
    elseif strcmp(class(per{1}.Ld),'frd')
        Ldf=cell(1,m);
        for j=1:m
            w1=per{j}.Ld.Frequency;
            x(:,1)=per{j}.Ld.ResponseData;
            Ldf{j} = interp1(w1,x,w{j},[],'extrap'); % Ldf{j} is a column vector
        end
    else
        Ldf=cell(1,m);
        for j=1:m
            Ldf{j}(:,1) = freqresp(per{j}.Ld,w{j}); % Ldf{j} is a column vector
        end
    
    end
    
    performance=per{1}.PerType;
    
else % if MIMO
    
    SISO=false;
    
    phi=cell(ni,no);
    if ~iscell(inphi)
        
        if strcmp(inphi.ConType,'PID') 
            [num,den]=tfdata(inphi.phi(3),'v');
            if den(1)==0,
                den(1)=1.2/wmax; %default value for tau (time constant of the derivator)
                inphi.phi(3)=tf(num,den);
            end
        end

        if strcmp(inphi.ConType,'PD') 
            [num,den]=tfdata(inphi.phi(2),'v');
            if den(1)==0,
                den(1)=1.2/wmax;  %default value for tau (time constant of the derivator)
                inphi.phi(2)=tf(num,den);
            end
        end
        
        
        phi(:,:)={inphi.phi};
    else
        for p=1:ni
            for q=1:no
                if strcmp(inphi{p,q}.ConType,'PID') 
                    [num,den]=tfdata(inphi{p,q}.phi(3),'v');
                    if den(1)==0,
                       den(1)=1.2/wmax; %default value for tau (time constant of the derivator)
                       inphi{p,q}.phi(3)=tf(num,den);
                    end
                end

                if strcmp(inphi{p,q}.ConType,'PD') 
                    [num,den]=tfdata(inphi{p,q}.phi(2),'v');
                    if den(1)==0,
                       den(1)=1.2/wmax;  %default value for tau (time constant of the derivator)
                       inphi{p,q}.phi(2)=tf(num,den);
                    end
                end
                
               
                phi{p,q}=inphi{p,q}.phi;
            end
        end
    end
    n=zeros(ni,no);
    for p=1:ni
        for q=1:no
            [n(p,q) , ~]=size(phi{p,q});
        end
    end
    
    for j=1:m
        for p=1:ni
            for q=1:no
                phif{j}{p,q}=freqresp(phi{p,q},w{j});
            end
        end
    end
    
    if ~iscell(inper)
        for j=1:m
            for q=1:no
                per{j}{q}=inper;
            end
        end
    elseif ~iscell(inper{1})
        for j=1:m
            per{j}=inper;
        end
    else
        per=inper;
    end
    
    Ldf=[];
    LDf=cell(1,m);
    if isempty(per{1}{1}.Ld)
        error ('You must specify Ld for MIMO models.');
    elseif strcmp(class(per{1}{1}.Ld),'frd')
        for j=1:m
            for q=1:no
                w1=per{j}{q}.Ld.Frequency;
                x(:,1)=per{j}{q}.Ld.ResponseData;
                LDf{j}(q,q,:) = interp1(w1,x,w{j},[],'extrap'); % LDf{j} is a 3-D array
            end
        end
    else
        for j=1:m
            for q=1:no
                LDf{j}(q,q,:)=freqresp(per{j}{q}.Ld,w{j});  % LDf{j} is a 3-D array
            end
        end
    
    end
        
    
    performance = per{1}{1}.PerType;
end

Gdim=[m , no , ni];

