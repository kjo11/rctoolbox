function phi = conphi(ConType,ConPar,CorD,F,ConStruc)

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
%       transfer functions.
%
% CorD : is a string that can be 's' or 'z' to define continuous-time or
%       discrete-time controller. If it is not assigned a continuous-time 
%       controller will be aconsidered as default.
%
% F: is a transfer function that is fixed in the controller (e.g. an integrator)
%
% ConStruc: is a string that can be 'LP' for a linearly parameterized
%       controller (default) or 'TF' for a rational controller expressed as
%       a transfer function (only for ConType 'Laguerre' or 'Generalized').
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
        
        
    otherwise
        
        error('This is not a supported controller type!')
        
end


if nargin > 3 && ~isempty(F)
    if ~strcmpi(ConStruc,'tf')
        phi.phi=minreal(F*phi.phi);
        phi.ConType =['Ftimes' phi.ConType];
    else
        phi.fs = F;
    end
end


