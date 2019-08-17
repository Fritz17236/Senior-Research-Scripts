% Simulation of Two Bidirectionally Coupled Wein-Bridge Oscillators,
% Voltage Traces. 
% Chris Fritz
% June 28th, 2016
clear
clc


%% Define Parameter Values (Circuit Component Values) 
C_1T = 100e-9 ;  % Capacitance of the Top capacitor for the 1st oscillator (Farads)
C_2T = 100e-9 ;  % Capacitance of the Top capacitor for the 2nd oscillator (Farads)

C_1B = 100e-9 ;  % Capacitance of the Bottom capacitor for the 1st oscillator (Farads)
C_2B = 100e-9 ;  % Capacitance of the Bottom capacitor for the 2nd oscillator (Farads)

R_1T = 8e3;      % Resistance of the Top resistor for the 1st oscillator     (Ohms)
R_2T = 9e3;      % Resistance of the Top resistor for the 2nd oscillator     (Ohms)

R_1B = 4e3;      % Resistance of the Bottom resistor for the 1st oscillator  (Ohms)
R_2B = 5e3;      % Resistance of the Bottom resistor for the 2nd oscillator  (Ohms)


R_1U = 15e3;      % Resistance of the upper resistor in the voltage divider branch for the 1st oscillator (Ohms)
R_2U = 14e3;      % Resistance of the upper resistor in the voltage divider branch for the 2nd oscillator (Ohms)

R_1L = 2.7e3;    % Resistance of the lower resistor in the voltage divider branch for the 1st oscillator (Ohms)
R_2L = 3.7e3;    % Resistance of the lower resistor in the voltage divider branch for the 2nd oscillator (Ohms)

R_12 = 62e3;     %Resistance of Coupling V_out of 2nd oscillator to V_in of 1st oscillator (Ohms)
R_21 = 62e3;     %Resistance of Coupling V_out of 1st oscillator to V_in of 2nd oscillator (Ohms)

e_v = .24;         %Nonlinearity of Diodes, Volts^^2 


%% Calculate Generalized Parameters (Epsilon, g, etc)
w_1 = sqrt( R_1T * R_1B * C_1T * C_1B).^-1;  %Natural frequency of the 1st oscillator
w_2 = sqrt( R_2T * R_2B * C_2T * C_2B).^-1;  %Natural frequency of the 2nd oscillator

e_1g = (R_1U / R_1L) * sqrt( (R_1B * C_1T) / (R_1T * C_1B) )...
       - sqrt( (R_1T * C_1T) / (R_1B * C_1B) ) ...
       - sqrt( (R_1B * C_1B) / (R_1T * C_1T) );     %Gain Coefficient for 1st Oscillator (unitless)

e_2g = (R_2U / R_2L) * sqrt( (R_2B * C_2T) / (R_2T * C_2B) )...
       - sqrt( (R_2T * C_2T) / (R_2B * C_2B) ) ...
       - sqrt( (R_2B * C_2B) / (R_2T * C_2T) );     %Gain Coefficient for 1st Oscillator (unitless)

e_12c = R_1B / R_12;    %Coupling ratio term for R_12
e_21c = R_2B / R_21;    %Coupling ratio term for R_21


%% Solve The Coupled Differential Equations
%Note: Solutions are elements of a vector X,
%X(1) is voltage of 1st oscillator, X(2) is its derivative, V_1'
%X(3) is voltage of 2nd oscillator, X(4) is its derivative, V_2'

%Differential Equations:
f = @(t,X) [ ...
%Voltage of 1st oscillator

    X(2);
%V' of 1st oscillator   
    (w_1.^2) * (...
    -X(1)*(1+e_12c) + ( (1/w_1)*X(2) )*(e_1g - e_12c*sqrt( (R_1T*C_1T)/(R_1B*C_1B) ) - 3*e_v*(R_1U/R_1L)*sqrt( (R_1B*C_1T)/(R_1T*C_1B) )*X(1).^2) ...
    + e_12c*(1 + R_2U/R_2L)*( X(3) + ( (1/w_1)*X(4) )*sqrt( (R_1T*C_1T)/(R_1B*C_1B) ) )...
    );
%Voltage of 2nd oscillator  
    X(4);
%V' of 2nd oscillator 
    (w_2.^2) * (...
    -X(3)*(1+e_21c) + ( (1/w_2)*X(4) )*(e_2g - e_21c*sqrt( (R_2T*C_2T)/(R_2B*C_2B) ) - 3*e_v*(R_2U/R_2L)*sqrt( (R_2B*C_2T)/(R_2T*C_2B) )*X(3).^2) ...
    + e_21c*(1 + R_1U/R_1L)*( X(1) + ( (1/w_2)*X(2) )*sqrt( (R_2T*C_2T)/(R_2B*C_2B) ) )...
    );
];
%Set Initial Conditions
c1 = .2;    %Voltage of 1st oscillator at t=0
c2 = 0;       
c3 = -.201;    %Voltage of 2nd oscillator at t = 0
c4 = 0;   
  
[t,xa] = ode15s(f,[0 :.000001:.1], [c1 c2 c3 c4]);

V1  = xa(:,1);   %Voltage of 1st Oscillator
V2 = xa(:,3);    %Voltage of 2nd oscillator

plot(t,V1,t,V2)
 
  
  
    
    
 %Check out  http://www3.nd.edu/~nancy/Math20750/Demos/3dplots/dim3system.html
 % for scripts to solver systems of ODE's
    
    
    
    
    
    
    
    
    
    
    