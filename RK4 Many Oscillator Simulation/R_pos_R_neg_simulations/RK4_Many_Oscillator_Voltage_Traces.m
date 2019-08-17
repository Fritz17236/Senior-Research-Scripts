% Simulation of Multiple Bidirectionally Coupled Wein-Bridge Oscillators,
% Voltage Traces. 
% Chris Fritz
% July 26 28th, 2016
clear
clc
close all
%% Simulation Parameters
N = 32;        %Number of oscillators
%% Define Parameter Values (Circuit Component Values) 
C  = 100e-9 ;   % Capacitance (Farads)
R  = 4.7e3;     % Frequency Control Resistance (Ohms)
R_1 =6e3;       % Gain Resistance 1(Ohms)
R_2  = 2.97e3;  % Gain Resistance 2(Ohms)
R_pos  = 62e3;  % Coupling Resistance to noninverting input(Ohms)
R_neg  = 61e3;  % Coupling resistance to inverting input
e_v = .24;      % Nonlinearity of Diodes, Volts^^2 
dt = 1e-5;
%% Solve The Coupled Differential Equations
%quick initial conditions:
c = rand(2*N,1);

%Solutions stored in X vector, which is 2NxT. 
f = @(t,X) derivative(X,N,C,R,R_1,R_2,R_pos,R_neg,e_v);
[t,xa] = ode45(f,[0 :dt :.4], c);


for i = 1:2*N
    if mod(i,2) == 1  %if i is odd,
        Vs(:,round(i/2)) = xa(:,i);
    else
        freqs(:,round(i/2)) = xa(:,i);
    end
end
%figure
figure
%plot(t,Vs)
h = surf(Vs');
set(h,'EdgeColor','none')
view(2)
title('R- = 50e3 Phase Versus Time 32 Bidirectionally Coupled Oscillators','FontSize',12);
xlabel('Timestep (dt = 1e-5 (s))','FontSize',12);
ylabel('Oscillator Number','FontSize',12);
ylim([ 0  32])
xlim([ 0 4e4])
%Check out  http://www3.nd.edu/~nancy/Math20750/Demos/3dplots/dim3system.html
 % for scripts to solver systems of ODE's
    

    
    
    
    
    
    
    