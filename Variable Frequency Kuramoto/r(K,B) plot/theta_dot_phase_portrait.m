%theta_dot  exploration
close all
clear
clc
%parameters
omega_rot = .1;    %frequency in rotating frame
b = 0;%2*pi;     %frequency strength parameter
K = .16;          % global coupling strength

%calculate K_c and r(K_c)
K_c = sqrt(8/pi)*.1;  %K_c using sigma of .1
r =  sqrt( 1 - (K_c/K) );
theta = linspace(0,2*pi,1000);

dot = omega_rot + b*cos(theta).^3 - K*r*sin(theta);

figure
plot(theta,dot)
axis([0 7 -1 1]);
hold
plot(theta,0)
