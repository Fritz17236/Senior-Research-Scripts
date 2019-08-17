% Kuramoto Oscillators Synchronization w/ order parmater
% Author: Christopher Fritz
% Version: 1.0a
% Date: 31/3/2016

%The purpose of this script is to simulate a series of N globally coupled
%oscillators described by the Kuramoto model of coupling. 
clear; close all; clc

%Parameters:
N_OSC = 100;                    %Number of Oscillators
dt = .1;                        %Time step
K =  .75;                       %Global Coupling Value 
TIME = 20;                      %Length of simulation (in miliseconds)
AVG_SPEED = .1;                 %average natural frequency of oscillators
SPEED_DEV  = .1 * AVG_SPEED;    %standard deviation of natural frequency (gaussian)
AVG_PHASE = pi/2;               %Initial average phase of each oscillator
PHASE_DEV = 10 * AVG_PHASE;     %Deviation of each oscillator from average phase (gaussian)


%Initialization
thetas = normrnd(AVG_PHASE,PHASE_DEV,1,N_OSC);        %initial phase of each oscillator
omegas = normrnd(AVG_SPEED,SPEED_DEV,1,N_OSC);        %natural frequencies of each oscillator,
t = 0;                                                %initialize time
count = 1;                                            %frame count
rho = thetas ./ thetas;                               %creates rho vector for graphing 
    
rs = zeros(1,TIME/dt);
ts = zeros(1,TIME/dt);      

%Movie Generation
writerObj = VideoWriter('animation.avi');
writerObj.FrameRate = 60;
open(writerObj)


%for a given amount of time
while t < TIME
   
    
    %each oscillator is updated according to the following:
    for i = 1:N_OSC       
        
        %for each oscillator
            
            %set/reset total difference to zero.   
            s = 0;    
            
            %sum the total difference of j oscillators to the ith oscillator
            for j = 1:N_OSC
                s = s + sin( thetas(j) - thetas(i) );  
            end
            
        %update the phase of the ith oscillator according to kuramoto
        %equation:    
        thetas(i) =  thetas(i) + dt .* ( omegas(i) + (K / N_OSC) *s ); 
        
    end
    
    %now calculate the order parameter
    
    %calculate the average phase:
    phi = sum(thetas)/(N_OSC);
    
    %sum the e^(i theta) terms
    s2 = 0;    
    for k = 1:N_OSC
        s2 = s2 + exp( 1i * (thetas(k)-phi) );
    end
    %final order parameter r
    r = abs( (1/N_OSC) * s2 ) ;
    
     
     %graph each oscillator on a radial plot  
     
    
     
     figure(1)
     subplot(1,2,1);
     plot(rho.*cos(thetas),rho.*sin(thetas),'.')
     title('Radial Plot of Oscillator Phases');
     axis([-1.2 1.2 -1.2 1.2 ]);
     set(gca,...
'XTickLabel','','YTickLabel','');
     %graph the order parameter
      subplot(1,2,2);
      scatter(ts,rs);
      title('Order Parameter Vs Time');
      axis([0 TIME 0 1.2]);
       M(count) = getframe;    %get frame for movie
       ts(count) = t;
       rs(count) = r;
       t  = t + dt;         %update time.
       writeVideo(writerObj,M(count))
       count = count + 1;   %update frame count

end
close(writerObj);
%plot(ts,rs);
