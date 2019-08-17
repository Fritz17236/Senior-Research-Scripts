
% Simulation Parameters
dt   = 0.01;  % Timestep
N    = 10;	   % Number of Oscillators
tmax = 10;    % Length of Simulation
K    = .75;    % Global Coupling Strength

% Vector initialization
thetas = zeros(N,tmax/dt);  % Vector containing Phase Values 
omegas = zeros(N,tmax/dt);  % Vector containing  Frequency Values
op     = zeros(1,tmax/dt);  % Vector to store order parameter
ts     = zeros(1,tmax/dt);  % Vector to store time


%Set initial Conditions
omegas(:,1)=normrnd(1,0.1,N,1);  % Initial Frequency follows a gaussian distribution
thetas(:,1)=normrnd(1,0.1,N,1);  % Initial Phase follows a gaussian distribution
s2=0;                       % sine squared starts at 0		
c2=0;                       % cosine squared starts at 0
s=0;                    	% sum variable starts at 0
r=0;                        % order parameter starts at 0
count = 1;                  % Time Iteration Counter
while t<tmax   % for loop to runs from time = 0 to t max

% Order Parameter
r = sqrt(c2.^2+s2.^2)/N;  % calculate the order paremeter by summing squares of sine and cosine sums of each oscillator phase
op(count) =r;		          % store order paramter in op wave
s2=0;c2=0;                % reset sine square and cosine squared to zero for next iteration


    for i=2:N               %for loop iterates through each oscillator and...

    %Sums over sine and cosine of the ith oscillator phase
    s2=s2+sin(thetas(i,count)); 
    c2=c2+cos(thetas(i,count));

    %Calculates the sum of the total weight/impact from every other oscillator, and 
        for j=1:N
            s=s+K*sin(thetas(j,count)-thetas(i,count));
        end
        
    thetas(i,count)= thetas(i-1,count)+(omegas(i,count)+(s/N))*dt;   % Calculates the next phase point and stores it in the phi vector
    s=0;
    end
 ts(t)= t;
 t = t + dt;
 count = count + 1;
end

