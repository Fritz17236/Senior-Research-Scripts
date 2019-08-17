%RK2 Kurmaoto Simulation
clear
clc
%simulation parameters
N = 100;  %Number of oscillators
K = .2/16;     %Global Coupling Strength
b = 5/16;     %Frequency Strength Paramter

%b = 5, w_o = 16
%initialization
omega_o = normrnd(1,.1/16,N,1);    %frequency for each oscillator
init_thetas = normrnd(pi,5,N,1);  %initial phases


f = @theta_dot;

    [t,xa] = ode15s(@(t,thetas) f(thetas,omega_o,K,b,t),[0:.1:500*16],init_thetas);


figure 
plot(t(1000:2000),sin(xa(1000:2000,:)))
figure
plot(theta_dot(xa(100:1000,1),omega_o(1),K,b,t)*.01)
figure 
plot(t,coherence(xa'))




