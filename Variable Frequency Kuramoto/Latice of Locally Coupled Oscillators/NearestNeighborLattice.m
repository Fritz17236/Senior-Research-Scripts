%This script simulates a lattice of NxN nearest neighbor coupled pulsing
%oscillators, using a simple Euler step numerical solver. 
clear
clc

%% SIMULATION PARAMETERS
dt = 1e-4   ;            %Timestep
N = 100;                 %Number of oscillators
omega = 3*pi;            %Average natural frequency
b = .99;                 %Frequency Strength Paramter
omega = omega/sqrt(1-b^2);
sigma = .02*omega;       %Standard deviation of frequencies
T =  3;                  %Maximum Time
K  = 1*omega*b;          %Copuling Strength


%% Initialization
ts = zeros(1,floor(T/dt));              %Initialize time vector
omega_o = normrnd(omega,sigma,N,N,1);   %Initial frequency for each oscillator
init_thetas =  normrnd(1.5*pi,1,N,N,1); %Initial phases
count = 1;                              %Initialize count variable
t_index = 0;                            %t_index starts at 0
xa = zeros(N,N,floor(T/dt));            %Initialize data vector for Phases vs Time
xa(:,:,1) = init_thetas;                %Initial Conditions



%% Run the simulation
while t_index < T - dt
    %calculate derivative
    d_thetas = theta_dot(xa(:,:,count),omega_o,K,b,t_index);

    %calculate and record next value, time
    next_val = xa(:,:,count) + dt.*d_thetas;
    xa(:,:,count+1) = (next_val);
    ts(count+1) = t_index+dt;

    %update time, count index
    t_index = t_index + dt;
    count = count + 1;
end

%Export Animated Simulation
matrix_movie(xa) 


