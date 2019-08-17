%RK2 Kurmaoto Simulation
clear
clc




%simulation parameters
dt = 1e-4 ;               %Timestep
N = 100;                 %Number of oscillators
omega = 8*pi;            %average natural frequency
b = 0.99;                 %Frequency Strength Paramter
%omega = omega/sqrt(1-b^2); %undo frequency modulation
sigma = .05*omega;       %standard deviation of frequencies
T =10;                 %Maximum Time

K = 1;
%initialization
t = zeros(1,floor(T/dt));
omega_o = normrnd(omega,sigma,N,1);   %frequency for each oscillator
init_thetas =  normrnd(1.5*pi,1,N,1);     %initial phases
count = 1; 
t_index = 0;
xa = zeros(N,floor(T/dt));            %Initialize data vector for Phases vs Time
xa(:,1) = init_thetas;                %set initial phases



%%% Run the simulation
    while t_index < T - dt
  d_thetas = theta_dot(xa(:,count),omega_o,K,b,t_index);   %calculate derivative
         ds(:,count+1) = d_thetas;
         next_val = xa(:,count) + dt.*d_thetas;         
         xa(:,count+1) = (next_val);                      %calculate and record next value
         [~, coses] = psis(xa(:,count));
         lambda(1,count+1) = omega*b*coses-K*coherence(xa(:,count));  %calculate stability                                                        %stability
                                                          
         t(count+1) = t_index+dt;

        t_index = t_index + dt;   %update time
        count = count + 1;        %update count\index #
    end
    
    cplot(t,coherence(xa),lambda);
    %{
PARAMS
sine_sum = 0;
for i = 1:N
    sine_sum = sine_sum +(xa(i,1));
end

psi_0 = sine_sum/N;
%initialization
N_ITER   = floor(T/dt);               %number of timesteps 
psi_vec  = zeros(1,N_ITER);    %vector containing psi values
count    = 1;                  %step number
t =0
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
    

plot(ts,sin(psi_vec),ts,psis(xa));
legend('Predicted','Simulated')
%}
%{
figure
line(ts,coherence(syncPhase),'Color','r')
ax1 = gca; % current axes
ax1.XColor = 'r';
ax1.YColor = 'r';

ax1_pos = ax1.Position; % position of first axes
ax2 = axes('Position',ax1_pos,...
    'XAxisLocation','top',...
    'YAxisLocation','right',...
    'Color','none');

line(ts,synced(1,:),'Parent',ax2,'Color','k')

%}