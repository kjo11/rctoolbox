function [] = check_Ld_stability(per,inG,phi)
if ~iscell(inG)
    inG = {inG};
end

for m=1:length(inG)
    G = inG{m};
    Ld = per{m}.Ld;
    
    if isa(G,'frd') || isa(Ld,'frd')
        % if G or Ld are FRD models, skip
        continue;
    end
    
    % Check closed-loop stability of Ld
    CLd = feedback(1,Ld);
    if isdt(CLd)
        x = isstable(absorbDelay(Cld));
    elseif isa(CLd,'ss') && ~isempty(CLd.InternalDelay) && CLd.InternalDelay ~= 0
        x = isstable(pade(CLd,10));
    else
        x = isstable(CLd);
    end
    if x==0
        warning('Ld appears to be closed-loop unstable.')
    end
    
    
    % get poles on stability boundary of Phi
    Phi = zpk([],[],0,phi.Ts);
    for i=1:size(phi,1)
        Phi = Phi + zpk([],pole(phi(i)),1,phi.Ts);
    end
    Phi = minreal(Phi); % lowest common denominator of phi
    [~,pphi_bd] = getpoles(Phi);

    % get poles of G
    [n_uns,p_bd] = getpoles(G);
    
    % combine poles of G and phi and sort
    p_bd = sort([p_bd; pphi_bd]);

    % get poles of L
    [nL_uns,pL_bd] = getpoles(Ld);
    pL_bd = sort(pL_bd);
    
    if length(p_bd)~=length(pL_bd) || sum(p_bd~=pL_bd)~=0
        warning('Ld and G*K should have the same poles on the stability boundary. This choice of Ld may generate an unstable controller.')
    elseif n_uns~=nL_uns
        warning('Ld and G*K should have the same number of unstable poles, but it appears that Ld has %i and G{%i}*K has %i. This choice of Ld may generate an unstable controller.',nL_uns,m,n_uns)
    end
end

end


function [n_uns,p_bd] = getpoles(G)
% Function to return the number of unstable poles of sys G and the location
% of poles on the stability boundary. If model has internal delays, use
% 10th order Pade approximation to check stability.
if isdt(G)
    p = pole(absorbDelay(G));
    n_uns = sum(abs(p)-1>eps);
    p_bd = p(abs(abs(p)-1)<eps);
else
    if isa(G,'ss') && ~isempty(G.InternalDelay) && G.InternalDelay ~= 0
%         disp('Model has internal delays. Using a 10th order Pade approximation to check stability.');
        p = pole(pade(G,10));
    else
        p = pole(G);
    end
    n_uns = sum(real(p)>eps);
    p_bd = p(abs(real(p))< eps);
end
end

