clear
clc

%Simulation Parameters:
b = 2*pi-.1;     %Frequency function gain parameter

f = @(t,theta) [ 2*pi + b*cos(theta).^3 ];
[t,xa] = ode45(f,[0:.001:4*pi],[0]);
%xa = wrapTo2Pi(xa);
plot(t,xa)
