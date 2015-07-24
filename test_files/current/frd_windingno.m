function [n_un,n_bd] = frd_windingno(Lfrd)

% check if smallest magnitude is at highest frequency
[~,n] = min(abs(Lfrd.ResponseData(:)));
if n~=length(Lfrd.ResponseData)
    warning('Ld does not appear to be strictly proper')
end

Lnew = Lfrd;
[~,n1] = max(abs(imag(Lnew.ResponseData(:))));
[~,n2] = max(abs(flipud(Lnew.ResponseData(:))));
n_bd = 0;

% Count number of poles of L at origin
% Multiply L by s until the low frequency response approaches the real axis
s = tf('s');
while n1==1 && n2==length(Lfrd.ResponseData)
    Lnew = Lnew*s;
    [~,n1] = max(abs(imag(Lnew.ResponseData(:))));
    [~,n2] = max(abs(flipud(Lnew.ResponseData(:))));
    n_bd = n_bd + 1;
    if n_bd > 3 % only go up to 3 poles
        disp('Could not evaluate winding number of L')
        n_un = -1;
        n_bd = -1;
        return;
    end
end

% ignore time delay in L (consistent with condesdata)
re = squeeze(real(Lfrd.ResponseData));
im = squeeze(imag(Lfrd.ResponseData));

if max(abs(re)) < eps || max(abs(im)) < eps
    n_un = 0;
    return;
end

if mod(n_bd,2)==1 % if odd number of poles, add 1 crossover point
    re = [-sign(im(1))*100*(max(abs(re))+1); re];
    im = [0.001*sign(im(1)); im];
end



xv = [re; flipud(re)];
yv = [im; -flipud(im)];

xv = [xv; xv(1)];
yv = [yv; yv(1)];



ind = (yv(1:end-1) < 0) - (yv(2:end) < 0); % find crossover points
n = find(ind~=0); % index of crossover points

% interpolate to get location of crossover
re_cross = zeros(size(n));
for i=1:length(n)
    re_cross(i) = interp1(yv(n(i):n(i)+1),xv(n(i):n(i)+1),0);
end

% Compute winding number/ adjust winding number based on number of poles on imaginary axis
wno = sum((re_cross < -1) .* ind(ind~=0)) + floor(n_bd/2);

n_un = - wno;
end