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
C  = 100e-9 ;  % Capacitance (Farads)
R  = 4.7e3;     % Frequency Control Resistance (Ohms)
R_1 = 18e3;     % Gain Resistance 1(Ohms)
R_2  = 2.97e3;  % Gain Resistance 2(Ohms)
R_C  = 10e6;   % Coupling Resistance (Ohms)
e_v = .24;     % Nonlinearity of Diodes, Volts^^2 
%% Solve The Coupled Differential Equations
%quick initial conditions:
c = 5*rand(2*N,1);

%Solutions stored in X vector, which is 2NxT. 
f = @(t,X) derivative(X,N,C,R,R_1,R_2,R_C,e_v);
[t,xa] = ode15s(f,[0 :.000001 :.1], c);


for i = 1:2*N
    if mod(i,2) == 1  %if i is odd,
        Vs(:,round(i/2)) = xa(:,i);
    else
        freqs(:,round(i/2)) = xa(:,i);
    end
end
figure
h = surf(Vs((3*end/4):end,:)');
set(h,'EdgeColor','none')
view(2)
 %Check out  http://www3.nd.edu/~nancy/Math20750/Demos/3dplots/dim3system.html
 % for scripts to solver systems of ODE's
    

    
    
    
    
    
    
    