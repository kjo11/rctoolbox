x0=5+3*1i;

ntheta = 5;

W1 = 3;
W2 = -5;
W3 = 2;
R = abs(W1)+abs(W2)+abs(W3);
x=R*cos(linspace(0,2*pi));
y=R*sin(linspace(0,2*pi));
r=zeros(ntheta,1);
r1=zeros(ntheta,1);
r2=zeros(ntheta^2,1);
rtot=zeros(ntheta^3,1);

for q=1:ntheta
    r(q)=R*exp(1i*2*pi*q/ntheta)/cos(pi/ntheta);
    r1(q)=W1*exp(1i*2*pi*q/ntheta)/cos(pi/ntheta);
    for q2=1:ntheta
        r2((q-1)*ntheta+q2) = W1*exp(1i*2*pi*q/ntheta)/cos(pi/ntheta) + W2*exp(1i*2*pi*q2/ntheta)/cos(pi/ntheta);
        for q3=1:ntheta
            rtot((q-1)*ntheta^2+(q2-1)*ntheta+q3) = W1*exp(1i*2*pi*q/ntheta)/cos(pi/ntheta) + W2*exp(1i*2*pi*q2/ntheta)/cos(pi/ntheta) + W3*exp(1i*2*pi*q3/ntheta)/cos(pi/ntheta);
        end
    end
end

r = [r;r(1)];
r1 = [r1; r1(1)];
r2 = [r2; r2(1)];
rtot = [rtot; rtot(1)];
figure; plot(r)
hold on; plot(rtot,'+r')
hold on; plot(x,y,'-g')

figure; plot(r)
hold on; plot(r1,'-r')
plot(r2,'+g')
plot(rtot,'xk')