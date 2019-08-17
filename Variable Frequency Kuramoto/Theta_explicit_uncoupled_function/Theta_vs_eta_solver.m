%Solve function for d_theta/d_eta
clear
clc
close all
%simulation parameters
omega  = 10*pi;      %natural frequency  of oscillator
b      = .99;        %frequency modulation
Kr     = 1;          %Coupling Term 
Omega  = 10*pi;      %mean natural frequency
eta_max      = .05;   %max eta
d_eta     = .001;    %eta step
psi    = pi/2;

%initialization
thetas    = zeros(1,eta_max/d_eta);
thetas(1) = 0;
etas      = zeros(1,eta_max/d_eta);
count     = 1;
eta       = 0;

while eta < eta_max
%calculate derivatives:
d_theta =  d_theta_d_eta(b,Kr,Omega,etas(count),thetas(count),psi);
%calculate and store next values for each vector
thetas(count+1) = thetas(count) + d_eta*d_theta;
etas(count+1)   = eta;

%update time and indices
count  = count + 1;
eta    = eta + d_eta;
end

plot(etas,thetas)
