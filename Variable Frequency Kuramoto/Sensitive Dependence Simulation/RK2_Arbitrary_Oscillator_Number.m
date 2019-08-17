%RK2 Kurmaoto Simulation
close all 
clear
clc
%simulation parameters
N = 100;  %Number of oscillators
K = .20/16;     %Global Coupling Strength
b =  5/16;     %Frequency Strength Paramter

%b = 5, w_o = 16
%initialization
%omega_o = normrnd(1,.1/16,N,1);    %frequency for each oscillator
%init_thetas = normrnd(pi,5,N,1);  %initial phases
omega_o  = ones(N ,1);
init_thetas = ones(N,1);
init_thetas(1:N/2,1) = pi;
init_thetas(1,1) = 1.001;
f = @theta_dot;

    [t,xa] = ode15s(@(t,thetas) f(thetas,omega_o,K,b,t),[0:.1:500*160],init_thetas);

xa = xa';
%figure 
%plot(t(:),sin(xa))
%figure
%plot(theta_dot(xa(100:1000,1),omega_o(1),K,b,t)*.01)
figure 
plot(t,coherence(xa))




