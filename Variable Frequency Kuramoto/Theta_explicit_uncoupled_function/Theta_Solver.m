%Solve function for theta_t
clear
clc
close all
%simulation parameters
eta    = .8/(1-.5);         %frequency perturbation
d_eta  = .01;       %change in eta for mapping space
eta_max = 1;


%numerically calculate max(theta) vs eta
etas = zeros(1,eta_max/d_eta);
theta_maxs = zeros(1,eta_max/d_eta);
eta_count = 1;
%while eta < eta_max
    
    Kr     = 1;             %Coupling Term 
    Omega  = 5*pi;          %mean natural frequency
    omega  = Omega + eta ;  %natural frequency  of oscillator
    T      = 100;           %max time
    dt     = .001;          %timestep
    b      = .5;           %frequency modulation

    %initialization
    thetas = zeros(1,T/dt);
    psis   = zeros(1,T/dt);
    count  = 1;
    t      = 0;
    ts     = zeros(1,T/dt);

    while t < T
    %calculate derivatives:
    d_theta =  omega.*(1+b.*sin(thetas(count)+psis(count))) ...
        - Kr.*sin(thetas(count)) - Omega*(1 + b*sin(psis(count)));
    d_psi =     Omega*(1+b*sin(psis(count)));
    %calculate and store next values for each vector
    thetas(count+1) = thetas(count) + dt*d_theta;
    psis(count+1)   = psis(count)   + dt*d_psi;

    %update time and indices
    ts(count+1) = t;
    count       = count +1;
    t  = t + dt;
    end
etas(eta_count) = eta;
theta_maxs(eta_count) = max(thetas);
eta = eta+d_eta;
eta_count = eta_count + 1;
%end
%plot(etas,theta_maxs);
psis = sin(psis);
%thetas = sin(thetas);
plot(ts,psis,ts,thetas)
legend('Psis', 'Thetas');
