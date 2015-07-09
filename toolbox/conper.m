function per = conper (PerType, Inpar, Ld)
%
% CONPER is used to define the desired control performance.
%
%   performance=conper(PerType, par, Ld)
%
% PerType : is a string that defines the performance type as follows
%
%       'GPhC': A lower bound on Gain margin, Phase margin and Crossover
%               frequency is guaranteed. This method can be used only for
%               stable systems.
%       'LS':   In Loop Shaping method the distance between L (open-loop transfer function)
%               and Ld (the desired one) in a number of frequency is
%               minimized. A lower bound on the Modulus margin (the inverse of the 
%               infinity norm of the sensitivity function) is also
%               guaranteed.
%       'Hinf': In this method the distance between L and Ld is minimized under 
%               some H infinity constraints on the weighted closed-loop sensitivity functions.      
%
% par : is a vector or a cell containing the required parameters for each
%       method. 
%
%       For the 'GPhC' performance type, par is [Gm, Phm, wc, Ku, wh],
%       where Gm is a lower bound for gain margin, Phm a lower bound for
%       phase margin and wc a lower bound for crossover frequency. Ku defines 
%       an upper bound on the controller gain in high frequencies wh < w <wmax. 
%       If wc is not defined the distance between L and Ld is
%       minimized. If Ld is not defined the controller gain at low frequencies 
%       is maximized (for PID controller and Laguerre basis functions). 
%       For the 'LS' method, par is [Mm, Ku, wh], where Mm is a lower bound on
%       the modulus margin.
%       For the 'Hinf' method, par is a cell, W, containing up to four weighting
%       filters W{1}, W{2}, W{3} and W{4}. The following constraints are applied:
%   
%           ||W{1} S|| <1,  ||W{2} T|| <1, ||W{3} KS|| <1, ||W{4} GS|| <1, 
%
%       where S=(1+GK)^(-1) and T=1-S are respectively sensitivity and complementary 
%       sensitivity functions. W{i} can be any LTI type model or frequency domain model 
%       (e.g. 'frd' model). 
%
% Ld : is the desired open-loop transfer function (or 'frd' model). It should contain the
%      poles on the stability boundary of the plant model and the controller as well as the 
%	   same number of unstable poles of the plant model. In fact, it should 
%      satisfies the Nyquist stability criterion.
%
%
% Examples:
% 
% performance=conper('GPhC',[2 60 1]);
% performance=conper('GPhC',[2 60 1 10 5.5]);
% performance=conper('LS',0.5,10/s);
%
% s=tf('s');W{1}=tf(0.5);W{2}=5*(s+1)/(s+10);
% performance=conper('Hinf',W, 1/(s*(s+2)));
%
%

    
if strncmpi(PerType,'GPhC',2)
        
        p=length(Inpar);
        if p<2
            error('You should specify at least the gain and the phase margin.')
        end
        
        if nargin > 2
            per.Ld=Ld;
        else
            per.Ld=[];
        end
        
        if Inpar(1) <= 1
            error('The gain margin should be greater than 1.');
        elseif Inpar(2) <= 0 || Inpar(2) >= 90
            error('The phase margin should be between 0 and 90 degrees.');
        end
        
        per.par=Inpar;
        per.PerType='GPhC';
        
elseif strncmpi(PerType,'LS',2)
        
        per.Ld=Ld;
        if nargin < 3
            error('Please specify a desired open-loop frequency function for loop shaping!');
        end
        
        if Inpar(1) < 0 || Inpar(1) > 1
            error('Modulus margin should be between 0 and 1.')
        end
        
        per.par=Inpar;
        per.PerType='LS';
        
elseif strncmpi(PerType, 'Hinf',2)
        
        
        if nargin > 2
            per.Ld=Ld;
        else
            error('A desired open-loop frequency function is needed!');
        end
        
        
        if ~iscell(Inpar)
            per.par=cell(1,4);
            per.par{1}=Inpar;
        else
            per.par=Inpar;
            for i=length(Inpar)+1:4
                per.par{i}=[];
            end
            
        end
        per.PerType='Hinf';
        
        
else
        
        error('This is not a supported control performance.')
        
end
