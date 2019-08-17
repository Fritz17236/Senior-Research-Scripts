% Kuramoto Oscillators Synchronization w/ order parmater
% Author: Christopher Fritz
% Version: 1.0a
% Date: 31/3/2016

%The purpose of this script is to simulate a series of N globally coupled
%oscillators described by the Kuramoto model of coupling. 
clear; close all; clc

%Parameters:
N_OSC = 100;                    %Number of Oscillators
dt = .1;                       %Time step
K =  .1;                        %Global Coupling Value 
TIME = 100;                     %Length of simulation (in miliseconds)
AVG_SPEED = .1;                 %average natural frequency of oscillators
SIGMA_SPEED  = .1;             %standard deviation of natural frequency (gaussian)
AVG_PHASE = pi/2;               %Initial average phase of each oscillator
SIGMA_PHASE = 10 * AVG_PHASE;   %Deviation of each oscillator from average phase (gaussian)
A = 0;                          %Amplitude of Driving Signal
W_D = AVG_SPEED;                %Frequency of Driving Signal

%Initialization
thetas = normrnd(AVG_PHASE,SIGMA_PHASE,1,N_OSC);        %initial phase of each oscillator
omegas = normrnd(AVG_SPEED,SIGMA_SPEED,1,N_OSC);        %natural frequencies of each oscillator,
t = 0;                                                %initialize time
count = 1;                                            %frame count
rs = zeros(1,TIME/dt);
ts = zeros(1,TIME/dt);      



%for a given amount of time
while t < TIME
   
    
    %each oscillator is updated according to the following:
    for i = 1:N_OSC       
        
        %for each oscillator
            
            %set/reset total difference to zero.   
            s = 0;    
            
            %sum the total difference of j oscillators to the ith oscillator
            for j = 1:N_OSC
                s = s + sin( thetas(j) - thetas(i) ) + K*A*sin( W_D*t - thetas(i) );  
            end
            
        %update the phase of the ith oscillator according to kuramoto
        %equation:    
        thetas(i) =  thetas(i) + dt .* ( omegas(i) + (K / N_OSC) *s ); 
        
    end
    
    %now calculate the order parameter
    
    %calculate the average phase:
    phi = sum(thetas)/(N_OSC);
    
    %sum the e^(i theta) terms
    s2 = 0; %reset sum from previous iteration   
    for k = 1:N_OSC
        s2 = s2 + exp( 1i * (thetas(k)-phi) );
    end
    
    %final order parameter r
    r = abs( (1/N_OSC) * s2 ) ;
   
    %tracking t & r for graphing
    ts(count) = t;
    rs(count) = r;
    
    t  = t + dt;         %update time       
    count = count + 1;   %update frame count

end
plot(ts,rs);
