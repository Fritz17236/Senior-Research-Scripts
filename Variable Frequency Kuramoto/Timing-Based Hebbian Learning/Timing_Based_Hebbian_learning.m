%Christopher Fritz
%25 July 2016

% Timing_baseds Hebbian Learning using an Euler step equation

close all
clear
clc

%simulation parameters
N = 20;                       %Number of oscillators
omega =2*pi;                 %average natural frequency
alpha = 0;                   %coactive adjustment parameter (not normalized)
b = .99;                     %frequency modulation parameter
omega = omega/sqrt(1-b.^2);  %demodulate omega using transform
sigma = .05*omega;           %standard deviation of frequencies
dt = 1e-3;                   %time step
T =  20;                     %max time
period = 2*(pi/omega);       %period in seconds
V_max = 60e-3;               %oscillator maximum voltage (milivolts);
beta = .1;
alpha_count = 1; 
%while alpha < 1;
    %sub initialization
    N_ITER      = floor(T/dt);
    omega_o     = normrnd(omega,sigma,N,1);   %initial frequency for each oscillator
    init_thetas = normrnd(1.5*pi,10*pi,N,1);   %initial phases
    init_Ks     = zeros(N,N,1);                %initial coupling constants
    thetas      = zeros(N,N_ITER);            %Vector containing phases
    Ks          = zeros(N,N,N_ITER);          %Vector Containing coupling constants in time
    count       = 1;                          %timestep counter (goes from 1-->T/dt)
    t           = zeros(1,N_ITER);            %vector containing time for plotting
    t_index     = 0;                          %time index variable
    pulse_count = 1;                          %pulse count'
    prev_count  = 1;                          %previous pulse count
    mean_changes= zeros(N,N);
    taus        = zeros(N,N,1);
    %set initial conditions
    thetas(:,1) = init_thetas;
    Ks(:,:,1)   = init_Ks;
    delta_Ks    = zeros(N,N,1);      




    %if there is space in the vector\time left
    while t_index < T -dt

            %check and calculate pulse times
            peaks = peak_finder(thetas(:,1:count),dt);
            pulse_count = numel(peaks(1,:));

            %calculate changes in K vector
            if pulse_count ~= prev_count
                last_pulse = count;
               even_increment = prev_count+1;
               prev_count = pulse_count;
            [changes_in_K(:,:,pulse_count), taus(:,:,pulse_count)] = K_changes(peaks(:,end),alpha,beta);
            mean_changes = mean(changes_in_K,3);
            end

            %calculate derivatives
            d_thetas = theta_dot(thetas(:,count),omega_o,Ks(:,:,count),b);   %calculate derivative
            delta_Ks     = mean_changes.*(1  - Ks(:,:,count) );
            means(:,:,count) = mean_changes;

            %calculate and store next value in vectors
            Ks(:,:,count+1)  = Ks(:,:,count) + delta_Ks*dt;

            thetas(:,count+1) = thetas(:,count) + dt*d_thetas;  

            %calculate and record next value
            t(count+1) = t_index+dt;

            t_index = t_index + dt;    %update time
            count = count + 1;  %update count\index #
    end
%{
mean_taus(:,:,alpha_count)= mean(taus,3);
alpha = alpha + .01;
alphas(alpha_count) = alpha;
alpha_count = alpha_count+1;
end
%}



 Vs = (1+sin(thetas));
figure
 plot(t,Vs);
figure
imagesc(Vs);
figure
imagesc(Ks(:,:,end));
colorbar
caxis([-1 1]);
