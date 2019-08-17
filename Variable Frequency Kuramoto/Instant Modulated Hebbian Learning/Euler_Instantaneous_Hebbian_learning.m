%Christopher Fritz
%25 July 2016

%Instantaneous Hebbian Learning using an Euler step equation

close all
clear
clc

%simulation parameters
N = 10;                      %Number of oscillators
omega = 2*pi;                %average natural frequency
alpha = 1;                  %coactive adjustment parameter
epsilon = 1;                %learning speed
b = .99;                     %frequency modulation parameter
omega = omega/sqrt(1-b.^2);  %demodulate omega using transform
sigma = .02*omega;           %standard deviation of frequencies
dt = 1e-3;                   %time step
T =   50;                   %max time
V_max  = 30;              %max voltage of oscillators (miliVolts)

%initialization
omega_o     = normrnd(omega,sigma,N,1);   %initial frequency for each oscillator
init_thetas = normrnd(0,0*pi,N,1);       %initial phases
%init_thetas(1:end/2)   = 1.5*pi;         %want first half of initial phases at quiescence
%init_thetas(end/2:end) = .5*pi;          %want second half of initial phases to pulse
init_Ks     = ones(N,N,1);                          %initial coupling constants
thetas      = zeros(N,T/dt);              %Vector containing phases
Ks          = zeros(N,N,T/dt);            %Vector Containing coupling constants in time
count       = 1;                          %timestep counter (goes from 1-->T/dt)
t           = zeros(1,T/dt);              %vector containing time for plotting
t_index     = 0;                          %time index variable


%set initial conditions
thetas(:,1) = init_thetas;
Ks(:,:,1)   = init_Ks;
for i = 1:N   
    Ks(i,i,1) = 0;    %want no self-coupling, all diagonal elements must be zero
end

    %if there is space in the vector\time left
while t_index < T -dt
        
        %calculate derivatives
        d_thetas = theta_dot(thetas(:,count),omega_o,Ks(:,:,count),b);   %calculate derivative
        delta_Ks     = dK(thetas(:,count),alpha,count,dt);
           
        %calculate and store next value in vectors
        thetas(:,count+1) = thetas(:,count) + dt*d_thetas;  
        Ks(:,:,count+1)  = Ks(:,:,count) + delta_Ks*dt;

        %calculate and record next value
        t(count+1) = t_index+dt;
        
        t_index = t_index + dt;    %update time
        count = count + 1;  %update count\index #
        
        
   
end
 Vs = (V_max/2).*(1+sin(thetas));
figure
 plot(t,Vs);
figure
imagesc(Vs);
figure
imagesc(Ks(:,:,end));