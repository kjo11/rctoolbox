function options = condesopt (varargin)
%
%   condesopt returns the default option sets for the CONDES command.
%
%   options=condesopt('Option1',Value1,'Option2',Value2,...)
%
%   The supporting options are:
%
%   'w' :       A vector of frequency points at which the constraints are evaluated. 
%               It can be a cell if different vectors are to be considered for 
%               different models in multimodel setting. In this case, w{i} is a vector 
%               of frequency points of model G{i}. The default value for LTI models is the
%               frequency vector given by the BODE command. 
%
%   'F' :       This is a weighting filter for L-Ld. For almost all
%               optimization problems an approximation of the two norm of 
%               F(L-Ld) is minimized. Its value is 1/(1+Ld) by default. F
%               should be set to tf(1) if no filter is desired.
%
%   'nq':       is an integer greater than 2 representing the number of vertices 
%               of a polygon that circumscribes the frequency domain model uncertainty 
%               circle in the Nyquist plot. If it is empty, the circle will not be approximated 
%               by a polygon and therefore a convex constraint is defined. In this case 
%               YALMIP interface should be used with a convex optimization solver 
%               (instead of LINPROG or QUADPROG).    
%
%   'lambda':   This option is used only for 'Hinf' performance. 
%               It indicates the sum of which weighted sensitivity functions should be 
%               less than 1. For example [1 1 0 0] means that the infinity norm of 
%               |W{1}S|+|W{2}T|, W{3}KS and W{4}GS will be less than 1  
%
%   'gamma':    This option is used only for 'Hinf' performance, when the infinity norm 
%               of the following vector should be minimized:
% 
%                   Lambda_1 |W{1}S|+Lambda_2|W{2}T|+Lambda_3|W{3}KS|+Lambda_4|W{4}GS|
% 
%               by a bisection algorithm. If all elements of Lambda are zero then
%               gamma is defined as an upper bound for all weighted sensitivity functions 
%               and will be minimized. For multimodel case the
%               maximum of gamma{i} is minimized for all models.'gamma' is a 
%               vector containing [g_min, g_max, tol] where g_min and g_max 
%               are the minimum and maximum value of gamma and tol is a small positive
%               number that indicates the tolerance of optimal gamma.
% 
%   'np':       This option is used if a gain-scheduled controller should
%               be designed. 'np' is a vector that indicates the degree of 
%               polynomials describing the gain-scheduled controller parameters.
%               For example np=[2 1] indicates that we have two scheduling
%               parameters. The first one is described by a second-order polynomial 
%               and the second one is linear.
%
%   'gs':       This option is used if a gain-scheduled controller should
%               be designed. 'gs' is a m by n matrix, where n is the number 
%               of scheduling parameters and m the number of operating points.
%               The i-th row of 'gs' contains the values of n scheduling
%               parameters that corresponds to the i-th model G{i}.
%
%   'ntheta':   This option is used for controllers with TF (transfer
%               function) structure. It is an integer greater than 2 
%               (default: 8) that determines the number of vertices used
%               to approximate the circle that determines the performance
%               constraints in the Nyquist diagram. If it is empty, the
%               the circle will not be approximated and a convex constraint
%               will be defined (YALMIP should therefore be used).
%
%   'TFtol':    This option is used for controllers with TF (transfer
%               function) structure. It should be a small, positive number.
%               The linear constraints are of the form Ax <= 0 and are 
%               replaced by Ax <= TFtol. Default: 1e-7.
%
%   'Gbands':   This option is used only for MIMO controller design. It
%               indicates whether the Gershgorin bands should be used for 
%               MIMO stability guarantee or not. Using Gershgorin bands implies
%               the use of an SDP solver and YALMIP. If this option turned
%               to 'off', LINPROG or QUADPROG will be used for optimization
%               but the stability should be verified a posteriori.
%
%   'yalmip':   is a string that can be set to 'on' to activate the YALMIP
%               interface. It should be activated when nq=[] and/or
%               Gbands='on' for multivariable controller design. SDPT3 is
%               used as the default solver but can be changed by 'solver'
%               option, e.g.
%               options=condesopt('yalmip','on','solver','sedumi').
%
%
%  The options related to the optimization problem solvers can be assigned 
%  with this command as well. For example, if for the control problem in hand 
%  uses the linear programming solver LINPROG, condesopt('MaxIter',100)
%  passes the number 100 for maximum iteration to the options of LINPROG
%  solver.
%
%


%
%   'beta':     This option can be used only for 'GPhC' performance
%               specification and indicates the angle of line d2 with real 
%               axis in degrees. The default value 45-Phm/2 is used when
%               beta is empty.



if (nargin == 0) && (nargout == 0)
    
    fprintf('                 w: []         (A cell object. w{i} is a vector of frequecy points of model G{i}) \n');
    fprintf('                 F: []         (A weighting filter for L-L_d) \n');
    fprintf('                nq: 8          (Number of vertices of a polygon that approximates the uncertainty circles) \n');      
    fprintf('             gamma: []         (a vector containing [g_min, g_max, tol] for bisection algorith in H infinity control) \n');
    fprintf('            lambda: [0 0 0 0]  ([1 1 0 0] means that the infinity norm of |W1S|+|W2T|  will be minimized in H infinity control) \n');
    fprintf('                np: []         (degree of polynomials describing the gain-scheduled controller parameters)\n');
    fprintf('                gs: []         (A vector (or matrix for more than one scheduling parameter) of the scheduling parameter values) \n');
    fprintf('            ntheta: 8          (Number of vertices of a polygon that approximates the performance constraints for controllers with TF structure\n');
%    fprintf('              beta: []         (the angle of line d_2 with real axis in degrees) \n');
    fprintf('            Gbands: on         (MIMO stablity conditions using Gershgorin bands on or off) \n');
    fprintf('            yalmip: off        (a string to choose between optimization toolbox of matlab or YALMIP) \n');
    fprintf('     solveroptions: []         (options determined for the solver) \n');
    
    fprintf('\n');
    return;
end

options.w=[];
options.F=[];
options.nq=8;
options.gamma=[];
options.lambda=[0 0 0 0];
options.np=[];
options.gs=[];
options.ntheta = 8;
options.Gbands='on'; % means taking into account Gershgorin's stablity conditions for MIMO systems
options.beta=[]; %degree
options.yalmip='off';
options.solveroptions=[];




allfields = {'w','Gbands','beta','np','gs','nq','ntheta','gamma','lambda','yalmip','F'};

if mod(nargin,2) ~= 0
    
    error ('Parameter-Value Mismatch: You must specify parameter-value pairs');
end


i=1;
while i<=nargin
    
    arg = varargin{i};
    
    if ~ischar (arg)
        
        error ('you must specify a valid field name as a string');
    end
    
    j = strcmpi(arg,allfields);
    
    if sum(j)
    
        [ntoto , k] = min(abs(j-1));
    
        options.(allfields{k})=varargin{i+1};
    else
        
        options.solveroptions.(arg)=varargin{i+1};
    end
    
    
    i = i + 2 ;
end


    
    
    