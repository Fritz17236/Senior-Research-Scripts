%psi diffeq solver
close all

%parameters
K = 1;
r = 1;
b = 1;
f = @(t,psi) [ (K*r*( sin(psi(1)-psi(2)) + sin(psi(2))) ); ( 1 + b*cos(psi(2)).^3 + K*r*sin(psi(1)-psi(2)) ) ];  
[t,xa] = ode15s(f,[0:.001:100], [pi/4 pi/4]);

xa(:,2) = wrapTo2Pi(xa(:,2));
figure
plot(t,xa);
title('Graph of psi and theta_i versus time')
figure
plot(t,sin(xa(:,1)-xa(:,2)))
title('graph of sine(psi-theta_i)')
