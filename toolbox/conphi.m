function phi = conphi(ConType,ConPar,CorD,F)

% In this command the controller structure is determined.
%
%  phi=conphi( ConType, ConPar, CorD, F)
%
% ConType : is a string defining the controller type. it can be:
%       'PID':          For PID controller
%       'PD' :          For PD controller
%       'PI' :          For PI controller
%       'Laguerre':     For Laguerre basis function
%       'Generalized':  For Generalized basis function
%       'UD':           For user defined structure
%       'SS':           For state space
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
%       transfer functions.
%       
%       For state space, ConPar is a vector containing the eigenvalues of 
%       the controller A matrix. ConPar can also be given as a cell where
%       ConPar{1} gives the eigenvalues of the A matrix and ConPar{2} gives
%       the C matrix of the controller. (By default the C matrix is 
%       [1 0 0 ...])
%
% CorD : is a string that can be 's' or 'z' to define continuous-time or
%       discrete-time controller. If it is not assigned a continuous-time 
%       controller will be considered as default.
%
% F: is a transfer function that is fixed in the controller (e.g. an integrator)
%
%
% Examples:
%   phi=conphi('PID');  % defines a continuous-time PID controller
%   phi=conphi('PD',0.01,'z');
%   phi=conphi('Generalized',[0.1 0.2 0.3],'s',1/s)
%   z=zpk('z',0.1);
%   phi=conphi('UD',[1/(z-1);1/(z*(z-1));1/(z^2*(z-1))])
%




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
%-------------------------

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
               tau=ConPar;
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
        [ntoto,n]=size(ConPar);
        if n >1, error('phi should be a column transfer function vector'); end 
        phi.phi=ConPar;
        phi.ConType='ud';
        
        
    case 'ss '
        if nargin > 3
            warning('Cannot define fixed part of the controller in state space')
        end

        if iscell(ConPar)
            ns = length(ConPar{1});
            a = poly(ConPar{1});
            C = ConPar{2};
            if size(C,2) ~= ns
                error('C must have the same number of columns as A')
            end
        else
            ns = length(ConPar);
            a = poly(ConPar);
            C = [1, zeros(1,ns-1)];
        end
        a = -a(2:end);
        A = full(spdiags(ones(ns,1),1,[a(:),zeros(ns,ns-1)]));
        
        
        if strcmp(CorD,'s')
            var = s;
            ConType = 'ss';
        else
            var = z;
            ConType = 'ssd';
        end
        
        if size(C,1) > 1
            phi = cell(size(C,1),1);
            for i=1:size(C,1)
                phi{i,1}.phi = transpose(C(i,:)/(var*eye(ns)-A));
                phi{i,1}.par.A = A;
                phi{i,1}.par.C = C;
                phi{i,1}.ConType = ConType;
            end
        
        else
            phi.phi = transpose(C/(var*eye(ns)-A));
            phi.par.A = A;
            phi.par.C = C;
            phi.ConType = ConType;
        end
            
        
        
        
    otherwise
        
        error('This is not a supported controller type!')
        
end


if nargin > 3 && isempty(strfind(phi.ConType,'ss'))
    phi.phi=minreal(F*phi.phi);
    phi.ConType =['Ftimes' phi.ConType];
end


