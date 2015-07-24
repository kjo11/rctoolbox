function [] = check_Ld_stability(per,inG,phi)
if ~iscell(inG)
    inG = {inG};
end

for m=1:length(inG)
    G = inG{m};
    Ld = per{m}.Ld;
    if isdt(phi)
        Ts = phi.Ts;
    else
        Ts = 0;
    end

    Phi = zpk([],[],0,Ts);
    for i=1:size(phi,1)
        Phi = Phi + zpk([],pole(phi(i)),1,Ts);
    end
    Phi = minreal(Phi); % lowest common denominator of phi

    [~,nphi_bd] = getpoles(Phi);

    if isa(G,'frd')
        n_uns = -1;
        n_bd = -1;
    else
        [n_uns,n_bd] = getpoles(G);
    end

    n_bd = n_bd + nphi_bd;

    if isa(Ld,'frd')
        [nL_uns,nL_bd] = frd_windingno(Ld);
    else
        [nL_uns,nL_bd] = getpoles(Ld);
    end

    if n_uns~=-1
        if n_bd~=nL_bd
            warning('Ld and G*K should have the same number of poles on the stability boundary, but it appears that Ld has %i and G{%i}*K has %i. This choice of Ld may generate an unstable controller.',nL_bd,m,n_bd)
        elseif n_uns~=nL_uns
            warning('Ld and G*K should have the same number of unstable poles, but it appears that Ld has %i and G{%i}*K has %i. This choice of Ld may generate an unstable controller.',nL_uns,m,n_uns)
        end
    else
        fprintf('Cannot evaluate stability of controller for FRD plant models. The Ld given will generate a stable controller for a plant with %i unstable poles and a plant/controller with %i poles on the stability boundary.',nL_uns,nL_bd);
    end
end

end


function [n_uns,n_bd] = getpoles(G)
if isdt(G)
    G = delay2z(G);
    p = pole(G);
    n_uns = sum(abs(p)>1);
    n_bd = sum(abs(p)==1);
else
    if isa(G,'ss') && ~isempty(G.InternalDelay) && G.InternalDelay ~= 0
        disp('Model has internal delays. Using a 10th order Pade approximation to check stability.');
        p = pole(pade(G,10));
    else
        p = pole(G);
    end
    n_uns = sum(real(p)>0);
    n_bd = sum(real(p)==0);
end
end

