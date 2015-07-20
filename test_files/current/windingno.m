close all
s = tf('s');
L = -5/s^3*(s+1)/(s-1)^5;
w = logspace(-3,3,1000);

Lfrd = frd(L,w);

Lnew = Lfrd;
[~,n] = max(abs(imag(Lfrd.ResponseData)));

n_boundary = 0;

% Count number of poles of L on imaginary axis
% Multiply L by s until the low frequency response approaches the real axis
while n==1
    Lnew = Lnew*s;
    [~,n] = max(abs(imag(Lnew.ResponseData(:)))); % index of maximum imaginary component
    n_boundary = n_boundary + 1;
    if n_boundary > 3 % only go up to 3 poles
        disp('Could not evaluate winding number of L')
        return;
    end
end

% ignore time delay in L (consistent with condesdata)
re = squeeze(real(Lfrd.ResponseData));
im = squeeze(imag(Lfrd.ResponseData));
% re = squeeze(real(freqresp(Lfrd,w)));
% im = squeeze(imag(freqresp(Lfrd,w)));

if mod(n_boundary,2)==1 % if odd number of poles, add 1 crossover point
    re = [-sign(re(1))*100*max(abs(re)); re];
    im = [0.001*sign(im(1)); im];
end

% adjust winding number based on number of poles on imaginary axis
% don't count poles on imaginary axis as unstable
wno = -floor(n_boundary/2) + n_boundary;


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

% Compute winding number
wno = wno + sum((re_cross < -1) .* ind(ind~=0));

