function phi = conphi(ConType,ConPar,CorD,F,ConStruc,ConOpt)

% In this command the controller structure is determined.
%
%  phi=conphi( ConType, ConPar, CorD, F, ConStruc)
%
% ConType : is a string defining the controller type. it can be:
%       'PID':          For PID controller
%       'PD' :          For PD controller
%       'PI' :          For PI controller
%       'Laguerre':     For Laguerre basis function
%       'Generalized':  For Generalized basis function
%       'UD':           For user defined structure
%
% ConPar : is a scalar or a vector of parameters for the chosen controller type
%
%       For continuous-time 'PID' or 'PD' controller ConPar can be the time constant
%       of the derivative part (if it is not specified a default value will be computed).
%
%       For discrete-time PI, PD and PID controllers, ConPar specifies the sampling period.
%
%       For continuous-time  Laguerre basis function, ConPar is [xi n] where xi is the parameter of 
%       Laguerre basis and n is its order. For discrete-time Laguerre basis function, ConPar is 
%       [Ts a n] where Ts is the sampling period, a the Laguerre basis parameter and n its order.
%       
%       For continuous-time generalized basis function, ConPar is xi, a n-th
%       dimensional vector defining the parameters of the generalized basis
%       function. For discrete-time generalized basis function, ConPar is
%       [Ts xi].
%
%       For user defined structure, ConPar is a column vector of stable
%       transfer functions. For state space, ConPar can also be a vector
%       Aeigs giving the eigenvalues of the A matrix (in discrete time:
%       [Ts Aeigs]).
%
% CorD : is a string that can be 's' or 'z' to define continuous-time or
%       discrete-time controller. If it is not assigned a continuous-time 
%       controller will be aconsidered as default.
%
% F: is a transfer function that is fixed in the controller (e.g. an integrator)
%
% ConStruc: is a string that can be:
%           'LP': linearly parameterized controller (default)
%           'TF': for a rational controller expressed as a transfer 
%                 function (only for ConType 'Laguerre' or 'Generalized')
%           'SS': for a state space representation
%
% ConOpt: for state space, is a cell with two entries: a string 'B' or 'C'
%       and a matrix giving the fixed B or C matrix for the controller
%       (default is C = [1 0 0 ...])
%
%
% Examples:
%   phi=conphi('PID');  % defines a continuous-time PID controller
%   phi=conphi('PD',0.01,'z');
%   phi=conphi('Generalized',[0.1 0.2 0.3],'s',1/s)
%   z=zpk('z',0.1);
%   phi=conphi('UD',[1/(z-1);1/(z*(z-1));1/(z^2*(z-1))])
%   phi=conphi('Laguerre',[0.01 0 5],'z',z/(z-1),'TF')
%   phi=conphi('PID',0.2,'s',[],'SS',{'C',[1 1 1 1]}) 




%-------------------------
default.tau=0;
%-------------------------

if nargin < 1
    error ('You should specify a controller type!');
end
%-------------------------

if (nargin < 3)
    CorD='s';
end
%-------------------------
if nargin < 5
    ConStruc = 'LP';
end
%-------------------------
if strcmp(CorD,'s')
    s=zpk('s');
else
    z=zpk('z');
end
%-------------------------

if ~ischar (ConType)
    error('The type of the controller must be entered as a char.');
end
%-------------------------
ConType = lower ([ConType,'  ']); % removes sensitivity to cases.
ConStruc = lower(ConStruc);
%-------------------------

if nargin < 5
    ConStruc = 'lp';
end

if strcmpi(ConStruc,'tf')
    phi.ConStruc = 'tf';
    if ~ (strncmp(ConType,'lag',3) || strncmp(ConType,'gen',3))
        error('ConStruc ''TF'' can only be used with ConType ''Laguerre'' or ''Generalized''')
    end
    phi.fs = tf(1,1);
elseif strcmpi(ConStruc,'lp')
    phi.ConStruc = 'lp';
end

switch ConType(1:3)
    
    case 'pid'
        
        if strcmp(CorD,'s')
            if nargin ==1
                tau=default.tau;
            end
            if nargin > 1
                if ~isempty(ConPar)
                    tau=ConPar;
                else
                    tau=default.tau;
                end
            end

            phi.phi=[1 ; 1/s ; s/(1+tau*s)];
            phi.ConType = 'PID';
        else
           
            phi.phi=[1 ; z/(z-1) ; (z-1)/z];
            phi.phi.Ts=ConPar(1);
            phi.ConType = 'PIDd';
        end
        
    case 'pi '
       
        if strcmp(CorD,'s')
            phi.phi=[1 ; 1/s];
            phi.ConType = 'PI';
            if nargin > 1
                if size(ConPar) ~= [0 0] %#ok<BDSCA>
                    disp('The value you entered as second input has nothing to do with the PI controller!');
                end
            end
        else
            phi.phi=[1 ; z/(z-1)];
            phi.phi.Ts=ConPar(1);
            phi.ConType = 'PId';
        end
        
    case 'pd '
        
        if strcmp(CorD,'s')
            if nargin ==1
                tau=default.tau;
            end
            if nargin > 1
                if ~isempty(ConPar)
                    tau=ConPar;
                else
                    tau=default.tau;
                end
            end
            phi.phi=[1 ; s/(1+tau*s)];
            phi.ConType = 'PD';
        else
            phi.phi=[1 ; (z-1)/z];
            phi.phi.Ts=ConPar(1);
            phi.ConType = 'PDd';
        end
        
        
    case 'p  '
        
        if strcmp(CorD,'s')
            a=zpk(1);
            phi.phi=a;
            phi.ConType = 'P';

            if nargin > 1
                if size(ConPar) ~= [0 0] %#ok<BDSCA>
                    disp('The value you entered as second input has nothing to do with the P controller');
                end
            end
        else
            a=zpk(1);
            phi.phi=a;
            phi.ConType = 'Pd';
        end
        
    case 'lag'
        
        if strcmp(CorD,'s')
            xi=ConPar(1); n=ConPar(2);
            phi.phi(1,1)=zpk(1);
            for j=2:n+1
                phi.phi(j,1)=sqrt(2*xi)*(s-xi)^(j-2)/(s+xi)^(j-1);
            end

            phi.ConType = 'Laguerre';
            phi.par=[xi n];
        else
            a=ConPar(2); n=ConPar(3); % -1 < a < 1
            phi.phi(1,1)=zpk(1);
            for j=2:n+1
                phi.phi(j,1)=sqrt(1-a^2)/(z-a)*((1-a*z)/(z-a))^(j-2);
            end

            phi.ConType = 'Laguerred';
            phi.phi.Ts=ConPar(1);
            phi.par=[a n];
        end
            
            
    
    case 'gen'
        
        if strcmp(CorD,'s')
            xi=ConPar;
            n=length(xi);

            phi.phi(1,1)=zpk(1);
            for j=2:n+1
                d=1;
                for k=1:j-2
                    d=d*(s-conj(xi(k)))/(s+xi(k));
                end
                phi.phi(j,1)=sqrt(2*real(xi(j-1)))/(s+xi(j-1))*d;
            end

            phi.ConType = 'generalized';
        else
            xi=ConPar(2:end);
            n=length(xi);

            phi.phi(1,1)=zpk(1);
            for j=2:n+1
                d=1;
                for k=1:j-2
                    d=d*(1-conj(xi(k))*z)/(z-xi(k));
                end
                phi.phi(j,1)=sqrt(1-abs(xi(j-1))^2)/(z-xi(j-1))*d;
            end

            phi.ConType = 'generalizedd';
            phi.phi.Ts=ConPar(1);
        end
        
    case 'ud '
        if ~isnumeric(ConPar)
            [~,n]=size(ConPar);
            if n >1, error('phi should be a column transfer function vector'); end 
            phi.phi=ConPar;
            phi.ConType='ud';
        elseif ~strcmp(ConStruc,'ss')
            error('phi should be a column transfer function vector');
        elseif ~isvector(ConPar)
            error('phi should be a column transfer function vector or a vector of eigenvalues of the A matrix');
        else
            phi.phi = [];
            if strcmp(CorD,'z')
                Ts = ConPar(1);
                ConPar = ConPar(2:end);
            else
                Ts = 0;
            end
            ns = length(ConPar);
            a = poly(ConPar);
            a = a(2:end);            
            phi.ConType = '';
        end
        
        
    otherwise
        
        error('This is not a supported controller type!')
        
end


if nargin > 3 && ~isempty(F)
    if ~strcmpi(ConStruc,'tf')
        phi.phi=minreal(F*phi.phi);
        phi.ConType =['Ftimes' phi.ConType];
    else
        phi.fs = minreal(1/F);
    end
end



if strcmp(ConStruc,'ss') && ~strncmp(ConType,'p  ',3)
    phi.par.flag = 0;
    % Determine eigenvalues
    if ~isempty(phi.phi)
        Ts = phi.phi.Ts;
        if strcmp(CorD,'s') && (strncmp(ConType,'pid',3) || strncmp(ConType,'pd ',3)) && tau==0
            a = []; % can't determine eigenvalues without derivative time constant
            ns = size(phi.phi,1)-1;
            phi.par.flag = 1;
            phi.ConStruc = 'ss';
        else
            Phi = zpk([],[],0,Ts);
            if isa(phi.phi,'tf')
                phi.phi = zpk(phi.phi);
            end
            for i=1:size(phi.phi,1)
                Phi = Phi + zpk([],phi.phi(i).p,1,Ts);
            end
            Aeigs = pole(minreal(Phi));
            ns = length(Aeigs); % number of states
            a = poly(Aeigs);
            a = a(2:end);
        end
    end
    
    
    % Determine B or C matrix
    if nargin < 6
        C = [1, zeros(1,ns-1)];
        B = [];
    elseif strcmpi(ConOpt{1},'b')
        B = ConOpt{2};
        if size(B,1) ~= ns
            error('B matrix should have the same number of columns as A')
        end
        C = [];
    elseif strcmpi(ConOpt{1},'c')
        B = [];
        C = ConOpt{2};
        if size(C,2) ~= ns
            error('C matrix should have the same number of rows as A')
        end
    else
        error('ConOpt{1} should be a string ''B'' or ''C''');
    end
    
    % Make A matrix from controllable canonical form
    if length(a)<2
        A = -a;
    else
        A = full(spdiags(ones(ns,1),1,[zeros(ns-1,ns); -flipud(a(:))']));
        if ~isempty(B) % if B matrix given, use observable canonical
            A = A';
        end
    end
    
    if isempty(C)
        ctr=ctrb(A,B);
        if rank(ctr)~=ns
            warning('The state space controller appears to have uncontrollable states for this choice of B')
        end
    else
        obs=obsv(A,C);
        if rank(obs)~=ns
            warning('The state space controller appears to have unobservable states for this choice of C')
        end
    end
    
    
    if strcmp(CorD,'s')
        var = zpk('s');
    else
        var = zpk('z',Ts);
    end
    
    % Make phi output
    if ~phi.par.flag
        if ~isempty(C) % If C matrix given
            if size(C,1) > 1 % If multiple outputs given
                phi = cell(size(C,1),1);
                for i=1:size(C,1)
                    phi{i,1}.phi = minreal(transpose(C(i,:)/(var*eye(ns)-A)));
                end
            else
                phi.phi = minreal(transpose(C/(var*eye(ns)-A)));
            end
        else % If B matrix given
            if size(B,2) > 1 % if multiple inputs given
                phi = cell(1,size(B,2));
                for i=1:size(B,2)
                    phi{1,i}.phi = minreal((var*eye(ns)-A)\B(:,i));
                end
            else
                phi.phi = minreal((var*eye(ns)-A)\B);
            end
        end
        
        if iscell(phi)
            phi{1,1}.par.A = A;
            phi{1,1}.par.B = B;
            phi{1,1}.par.C = C;
            for i=1:length(phi)
                phi{i}.phi(end+1,1) = zpk([],[],1,Ts);
                phi{i}.ConStruc = 'ss';
                phi{i}.ConType = 'ss';
            end
        else
            phi.par.A = A;
            phi.par.B = B;
            phi.par.C = C;
            phi.phi(end+1,1) = zpk([],[],1,Ts);
            phi.ConStruc = 'ss';
            phi.ConType = 'ss';
        end
    else
        phi.par.B = B;
        phi.par.C = C;
    end
end



