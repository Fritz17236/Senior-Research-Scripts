
%% Setup and Header
%Christopher Fritz
%I_Na,p + I_K model (Reduced); 
%2 Neurons Are Gap-Junction Coupled
%The first Neuron is driven by current I,
%The second is undriving, except for coupling to other neuron
% 10/10/2016
clear;
clc;
close all;

%% Diffeqs Describing the System: 

% C(dV/dt) = I - g_L * (V - E_L) - g_Na * m_inf(V) * (V - E_Na)
         %   - g_K * n(V) *(V - E_K)
 
% dn/dt = (n_inf(V) - n) / tau_n (V) 
% assume m = m_inf 
%
% 
% V and n are the dynamical variables we wish to graph/analyze:
 
%--------------------------------------------------------------------------

% Steady State Activation Curve is approximated by the Boltzmann Function:
% m_inf(V) = [  1 + exp{ (V_1/2 - V) / k }  ] ^-1 ; 
        % m_inf(V_1/2) = .5
        % k = slope factor: smaller k--> steeper curve
        
% The voltage sensitive time-constant is modelled by the Gaussian Function:
% tau(V) = C_base + C_amp * exp{ -(_Vmax - V)^2  / sigma^2 }  
        % C_base = lowest value function reaches after Gaussian Decay
        % C_amp  = Height of Gaussian at Max from C_base 
        % V_max  = Value at which Gaussian is Maximum
        
%--------------------------------------------------------------------------
%% Physical Parameters (as defined in Izhikevich fig. 4.1, pg. 90):
C      = 1;     %Mean Capacitance                        (micro? F)
I      = 40;    %Mean Total Current Flow            (mA / cm^2)
E_L    = -80;   %Leak Current Equilibrium Potential  (mV)
E_Na   = 60;    %Sodium Equilibrium Potential        (mV)
E_K    = -90;   %Potassium Equilibrium Potential     (mV)
g_L    = 8;     %Leak Current Conductance            (mS/cm^2)
g_Na   = 20;    %Sodium Current Conductance          (ms(cm^2)  
g_K    = 10;    %Potassium Current Conductance       (mS/cm^2)
m_half = -20;   %Half-Voltage of m curve             (mV)
k_m    = 15;    %Slope factor of m curve             (mV)
n_half = -25;   %Half-Voltage of n curve             (mV)
k_n    = 5;     %Slope factor of n curve             (mV)
tau    = 1;     %Voltage Sensitive time-constant     (sec)
K      = .2;    %Coupling Constant (Conductance)     (mS/cm^2)
 
%% Simulation Parameters
N      = 50;      %Number of Simulated Neurons
dt     = .001;   %Time Step Interval             (s)
V_0    = 30;     %Initial Voltage                (mV)
n_0    = .50;    %Initial Activation of K+ gates (probability)
T      = .02; 
%% Initialization
Is       = normrnd(I,0*I,N,1);       %Gaussian distribution of current
Cs       = normrnd(C,.1*C,N,1);      %Gaussian distribution of capacitance
V_t      = zeros(N,T/dt);            %Membrane Potential
n_t      = zeros(N,T/dt);            %K+ activation-gate proability
m_inf    = zeros(N,T/dt);            %Steady-State Activation of Sodium
n_inf    = zeros(N,T/dt);            %Steady-State Activation of Potassium
V_t(:,1) = -normrnd(V_0,0*V_0,N,1);  %Random initial voltages
n_t(:,1) = n_0;                      %Initial K+ Conditions
count    = 1;
ts       = zeros(1,T/dt);

%%Run The Simulation
 
%For Each Iteration:
for i = 1:dt:T/dt
    for j = 1:N
   %Calculate Steady State Acvitation Functions
   m_inf(j,count) = (  1 + exp( ( m_half - V_t(j,count) ) / k_m )  ).^-1; 
   
 
   n_inf(j,count) = (  1 + exp( ( n_half - V_t(j,count) ) / k_n )  ).^-1; 
   
   
 
   %Calculate and Record Next Voltage and K+ values, insert noise 
   V_t(j,count+1)  = awgn(V_t(j,count) +  (   Is(j,1) - g_L * (V_t(j,count) - E_L)...
            - g_Na * m_inf(j,count) * (V_t(j,count) - E_Na) ...
            - g_K * n_t(j,count) *(V_t(j,count) - E_K) + (K/N)*sums(V_t(:,count)) )*(dt/Cs(j,1)),50);
        
   n_t(j,count+1) = (n_t(j,count) + ( (n_inf(1,count) - n_t(1,count)) / tau ) * dt) ; 
   
    end
    %update time
    ts(1,count+1) = ts(1,count) + dt;
    count = count +1;
end
 


%%Plot Phase Portrait and Voltage Trace

figure 
plot(ts,V_t)
title('Membrane Potential vs Time')
xlabel('Time (s)');
ylabel('Membrane Potential (mV)');

save('50_neurons.mat')








