% Matlab Code to Simulate a Single Wien-Bridge Oscillator for varying
% values of b, a phenomenological constant
close all
clear
clc
%The equation has the form:
% V'' + (2 - R1/R2)V' + V = 0;
%R_2 = R_20 ( 1 + b V^2);

% The term (Vout_i+1 + Vout_i-1 ) is interpreted as 2* V_1 since there are
% only 2 oscillators, likewise with the prime terms (V_1' etc)


%Physical Parameters
R_1  =30e3;    %Upper Resistance (Ohms)
R_20 = 2.7e3;    %Lower Resitance  (Ohms)
b    = 9;      %Nonlinearity Parameter (Phenomenological Constant)
R_pos = 62e3;  %non_inverting coupling resistor (Ohms)
R_neg = 62e3; %inverting coupling resistor     (Ohms)
R     = 4e3;   %Filter circuit resistor (Ohms)

%Simulation Parameters
T  = 100;    %Total time (s)


%run the simulation
f = @(t,X) [ ...
    %Solver uses vector of derivates to find equation. 1st entry in vector
    %is variable, V, second is variable V', Since dV/dt = V', 1st entry is
    % variable to be solved for in the second place of the vector;
    %dV/dt = V'
    X(2);
    ...
    %dV'/dt = - (2 - R1/R2)V' - V = 0;
    -( 2 -  (R_1/R_2(R_20,X(1),b)))*X(2) - X(1);
  ];

[t,solns] = ode45(f, [0 T], [.1 0]);
solns = solns';
V = solns(1,:);
V_prime = solns(2,:);

%Now calculate the phase shift between the signals and store it
complex_driver = hilbert(V);



figure(1)
plot(V,V_prime);





