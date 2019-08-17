%this script simulates the psi vector
clc
clear 
close all

%params:
psi_0 =  (3/2)*pi;    %initial mean phase
dt    =   1e-3;       %time step
omega =   4*pi;       %mean frequency
b     =   .99;        %frequency modulation parameter
T     =   20;         %total time


%initialization
N_ITER   = T/dt;               %number of timesteps 
psi_vec  = zeros(1,N_ITER);    %vector containing psi values
ts       = zeros(1,N_ITER);    %vector containing time
count    = 1;                  %step number
t       = 0;

%calculate initial condition constant, C
beta     = sqrt(1-b.^2);
init_tan = tan(psi_0/2); 
C    = (-2/beta)*atan( (b+init_tan)/beta );



while t < T
    %calculate psi value, store time and calculated value
    tan_term         = tan( beta*(omega*t - C)/2 );
    psi_vec(1,count) = 2 * atan(beta * tan_term - b );
    ts(1,count)      = t;
    
    %update time and count indices
    t     = t + dt;
    count = count +1;
end

%unwrap psi vector
psi_vec = unwrap(psi_vec);

