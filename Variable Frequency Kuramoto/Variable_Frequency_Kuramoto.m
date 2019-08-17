% Variable Frequency Kuramoto Model %
%Christopher Fritz July 7th, 2016

%Variable frequency uses a modified Kuramoto oscillator set, by inserting a
%phase dependence on the natural frequency of each oscillator:
% w(theta) = 1+cos(theta).^4
% This term replaces the natural frequency term in the kuramoto model thus:

%dtheta_dt = w(theta) + ( K/N )* SUM( sin( theta(j) - theta(i) ) )

clear
clc
%This simulation starts with only two oscillators

%Simulation Parameters:
b = 10;     %Frequency function gain parameter

f = @(t,theta) [...
    (1 + b*cos(theta(1)).^2 + .75*(sin(theta(2) - theta(1))) ); ... 
    (1.01 + b*cos(theta(2)).^2) + .75*sin(theta(1) - theta(2))];
[t,xa] = ode45(f,[0 10*pi],[0 0]);
plot(t,wrapTo2Pi(xa))



