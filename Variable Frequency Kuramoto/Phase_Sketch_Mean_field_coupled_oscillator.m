%Phase Sketch, Single Oscillator coupled to Mean field
clear
clc

%d_theta = omega + b cos(theta)^3 - Krsin(theta)
omega = .6; %natural frequency
b     = .99;  %frequency modulation parameter
Kr    = .5;   %coherence coupling product

theta = linspace(0,2*pi,1000);

d_theta = omega + (b*omega).*cos(theta).^3 - Kr.*sin(theta);

plot(theta,d_theta,theta,0)