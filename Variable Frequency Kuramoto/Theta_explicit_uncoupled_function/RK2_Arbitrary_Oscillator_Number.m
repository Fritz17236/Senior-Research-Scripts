%RK2 Kurmaoto Simulation
close all
clear
clc
%simulation parameters
dt = 1e-5;               %Timestep
N = 1;                   %Number of oscillators
omega = 10*pi;            %average natural frequency
sigma = .04*omega;       %standard deviation of frequencies
b = .99;                 %Frequency Strength Paramter
T = 4;                 %Maximum Time
  
    t = zeros(1,T/dt);
    omega_o = 10*pi;   %frequency for each oscillator
    init_thetas = 3*pi/2;     %initial phases
    count = 1; 
    t_index = 0;
    xb = zeros(N,T/dt);      %Initialize data vector for Phases vs Time
    xb(:,1) = init_thetas;   %set initial phases
    
    K = 0;
    
    while t_index < T
    
    d_thetas = theta_dot(xb(1,count),omega_o,K,b,t_index);   %calculate derivative
    xb(:,count+1) = xb(:,count) + dt*d_thetas;         %calculate and record next value
    t(count+1) = t_index+dt;
    t_index = t_index + dt;         %update time
    count = count + 1;  %update count\index #

    end
 

plot(t,sin(phi_t(t,b,omega)),t,sin(xb))

for i = 0:3
    vline(pulse_time(b,omega,i),'b');
end