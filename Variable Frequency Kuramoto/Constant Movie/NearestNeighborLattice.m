%This script simulates a lattice of NxN nearest neighbor coupled pulsing
%oscillators.


%% SIMULATION PARAMETERS
dt = 1e-4  ;            %Timestep
N = 100;                  %Number of oscillators
omega = 300*pi;           %average natural frequency
b = 0.99;               %Frequency Strength Paramter
omega = omega/sqrt(1-b^2);
sigma = .01*omega;      %standard deviation of frequencies
T =  5;                %Maximum Time
K  = .8*omega*b;                 %Copuling Strength
 



%% Initialization
ts = zeros(1,floor(T/dt));            %initialize time vector
omega_o = normrnd(omega,sigma,N,N,1);   %initial frequency for each oscillator
init_thetas =  normrnd(1.5*pi,1,N,N,1); %initial phases
count = 1;                            %initialize count variable
t_index = 0;                          %t_index starts at 0
xa = zeros(N,N,2);          %Initialize data vector for Phases vs Time


xa(:,:,1) = init_thetas;              %set initial phases


 t = 0;
        writeVideo(writerObj,M(count))


writerObj = VideoWriter('animation.avi');
writerObj.FrameRate = 30;
open(writerObj)
count = 1;
%for a given amount of time
    
%% Run the simulation
    while t_index < T - dt
         %calculate derivative
         d_thetas = theta_dot(xa(:,:,1),omega_o,K,b,t_index);  
         
         %calculate the next value
         next_val = xa(:,:,1) + dt.*d_thetas;         
         xa(:,:,2) = (next_val);  
         
         ts(count+1) = t_index+dt;
         figure(1)
         imagesc(sin(xa(:,:,2)));
        M(count) = getframe;    %get frame for movie
        writeVideo(writerObj,M(count))
         
         
         %update time, count index
         t_index = t_index + dt; 
         t = t + dt;
         count = count + 1;

    end
close(writerObj);


    
    
    


