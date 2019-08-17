%% Chimera State Simulation in a Ring of Relaxation-Type Oscillators with Local Coupling
close all
clear
clc
%% simulation parameters
b = 0.99;                 %Nonlinearity Paramter
alpha = .5*pi/4;            %Phase delay parameter (Sakaguchi Model)
dt = 1e-5  ;             %Timestep
N = 32;                  %Number of oscillators
omega = 3*pi;         %average natural frequency
omega_orig = omega;      %Store original frequency
omega = omega/sqrt(1-b^2); %Demodulate Frequency so simulation gives desired frequency

sigma = .05*omega_orig;   %Standard deviation of frequencies (0 in chimera state)
T =  3;                 %Maximum Time
K = 1;                 %Coupling Strength

%% Initialization
t = zeros(1,floor(T/dt));             %Time Vector
omega_o = normrnd(omega,sigma,N,1);   %frequency for each oscillator
init_thetas =  normrnd(1.5*pi,0,N,1);     %initial phases
count = 1; 
t_index = 0;
xa = zeros(N,floor(T/dt));            %Initialize data vector for Phases vs Time
xa(:,1) = init_thetas;                %set initial phases



   


%% Run the simulation
    while t_index < T - dt
  d_thetas = theta_dot(xa(:,count),omega_o,K,b,t_index);   %calculate derivative
         ds(:,count+1) = d_thetas;
         next_val = xa(:,count) + dt.*d_thetas;         
         xa(:,count+1) = (next_val);                      %calculate and record next value
        t(count+1) = t_index+dt;

        t_index = t_index + dt;   %update time
        count = count + 1;        %update count\index #
    end

for i = 1:N
    freqs(i) = ( xa(i,end) - xa(i,1) ) ./ T;
end



figure(2)
imagesc(sin(xa))
set(gca,'YDir','normal')
