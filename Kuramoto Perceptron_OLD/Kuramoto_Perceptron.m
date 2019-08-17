%Kuramoto perceptron: 
%1) Receive training frequency from stimulus function
%2) Generate gaussian distribution of frequencies around training frequency
%3) Tune N_OSC Kuramoto oscillators to this distribution of natural frequency
%4) Allow Oscillators to run, starting globally coupled at at K = K_c
%5)  calculate coherence, r_net
%6) Normalize stimulus, compare to r
%7) Compute gradient of C(K_ij)
%8) Update K_ij according to gradient descent function\
%9) After training 'period' has expired, choose different stimulus, return
%to 1

%% Simulation Parameters
N_OSC    = 10;  %Number of Kuramoto Oscillators
dt       =.0001;  %timestep
T        = 10;  %total training time   
K_o        = .5;  %Initial coupling
%% 1: Receive Training Frequency from stimulus function
stimulus = -20;
firing_rate = response(stimulus);  
firing_rate = 2*pi*firing_rate;    %convert to radians



%% 2: Generate Gaussian Distribution of Frequencies around Training Frequency
mu    = firing_rate;                %Curve centered about training frequency
sigma = firing_rate*.1;             %With a 10% standard deviation
nat_freq = normrnd(mu,sigma,N_OSC); %Natural Frequencies for N_OSC oscillators

%% 3: Tune N_OSC Kuramoto Oscillators to this frequency distribution

for i = 1:N_OSC  %initialize vector of oscillators
    omegas(i) = nat_freq(i);
end
thetas = zeros(N_OSC,1);

%Initialization
t = 0;                                   %initialize time
count = 1;                               %frame count
rho = thetas ./ thetas;                  %creates rho vector for graphing 

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
            
            %sum the total difference (Sin) of j oscillators to the ith oscillator
            for j = 1:N_OSC
                s = s + sin( thetas(j) - thetas(i) );  
            end
            
        %update the phase of the ith oscillator according to kuramoto
        %equation:    
        thetas(i) =  thetas(i) + dt .* ( omegas(i) + (K / N_OSC) *s ); %
        
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
     %subplot(1,2,1);
     plot(rho.*cos(thetas),rho.*sin(thetas),'.')
     axis([-1.2 1.2 -1.2 1.2 ]);
     set(gca,...
'XTickLabel','','YTickLabel','');
     %graph the order parameter
   %  subplot(1,2,2);
  %   bar(r);
  %   axis([0 1 0 1]);
        M(count) = getframe;    %get frame for movie
         ts(count) = t;
         rs(count) = r;
         t  = t + dt;         %update time.
        writeVideo(writerObj,M(count))
        count = count + 1;   %update frame count

end
close(writerObj);


%% 6: Normalize stimulus (in degrees)
% stimulus ranges from -40 to 40.  Let -40 be 0 and 40 be 80, 
% 0 corresponds to 0 and 80 corresponds to 1, thus
r_correct = (stimulus + 40) / 80;
%% 7: Compute Gradient of C(K_ij);

