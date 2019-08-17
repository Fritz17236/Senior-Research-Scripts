clear
clc

%Simulation Parameters:
b = 10;     %Frequency function gain parameter

f = @(t,theta) [ 0.08 + b*cos(theta).^2 ];
[t,xa] = ode45(f,[0:.001:4*pi],[0]);
%xa = wrapTo2Pi(xa);
plot(t,xa)
