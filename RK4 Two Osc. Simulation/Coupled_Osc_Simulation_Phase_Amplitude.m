% Simulation of Two Bidirectionally Coupled Wein-Bridge Oscillators %
% Chris Fritz
% June 28th, 2016
close all
clear
clc

%% Define Parameter Values (Circuit Component Values) 
C_1T = 100e-9 ;  % Capacitance of the Top capacitor for the 1st oscillator (Farads)
C_2T = 100e-9 ;  % Capacitance of the Top capacitor for the 2nd oscillator (Farads)

C_1B = 100e-9 ;  % Capacitance of the Bottom capacitor for the 1st oscillator (Farads)
C_2B = 100e-9 ;  % Capacitance of the Bottom capacitor for the 2nd oscillator (Farads)

R_1T = 4e3;      % Resistance of the Top resistor for the 1st oscillator     (Ohms)
R_2T = 4e3;      % Resistance of the Top resistor for the 2nd oscillator     (Ohms)

R_1B = 4e3;      % Resistance of the Bottom resistor for the 1st oscillator  (Ohms)
R_2B = 4e3;      % Resistance of the Bottom resistor for the 2nd oscillator  (Ohms)


R_1U = 6e3;      % Resistance of the upper resistor in the voltage divider branch for the 1st oscillator (Ohms)
R_2U = 6e3;      % Resistance of the upper resistor in the voltage divider branch for the 2nd oscillator (Ohms)

R_1L = 2.7e3;    % Resistance of the lower resistor in the voltage divider branch for the 1st oscillator (Ohms)
R_2L = 2.7e3;    % Resistance of the lower resistor in the voltage divider branch for the 2nd oscillator (Ohms)

R_12 = 62e3;     %Resistance of Coupling V_out of 2nd oscillator to V_in of 1st oscillator (Ohms)
R_21 = 62e3;     %Resistance of Coupling V_out of 1st oscillator to V_in of 2nd oscillator (Ohms)

e_v = .24;         %Nonlinearity of Diodes, Volts^^2 
%%

%% Calculate Generalized Parameters (Epsilon, g, etc)
w_1 = sqrt( R_1T * R_1B * C_1T * C_1B).^-1;  %Natural frequency of the 1st oscillator
w_2 = sqrt( R_2T * R_2B * C_2T * C_2B).^-1;  %Natural frequency of the 2nd oscillator

e_1g = (R_1U / R_1L) * sqrt( (R_1B * C_1T) / (R_1T * C_1B) )...
       - sqrt( (R_1T * C_1T) / (R_1B * C_1B) ) ...
       - sqrt( (R_1B * C_1B) / (R_1T * C_1T) );     %Gain Coefficient for 1st Oscillator (unitless)

e_2g = (R_2U / R_2L) * sqrt( (R_2B * C_2T) / (R_2T * C_2B) )...
       - sqrt( (R_2T * C_2T) / (R_2B * C_2B) ) ...
       - sqrt( (R_2B * C_2B) / (R_2T * C_2T) );     %Gain Coefficient for 2nd Oscillator (unitless)

e_12c = R_1B / R_12;    %Coupling ratio term for R_12
e_21c = R_2B / R_21;    %Coupling ratio term for R_21
%%

%% Solve The Coupled Differential Equations
%Note: Solutions are elements of a vector X,
%X(1) is amplitude of 1st oscillator, X(3) is its phase

%Differential Equations:
f = @(t,X) [ ...
% amplitude of 1st oscillator
    w_1 * (X(1) / 2) * ( ...
         e_1g - (R_1B/R_12) * sqrt( (R_1T*C_1T) / (R_1B*C_1B) )...
         - ( 3*e_v*R_1U / R_1L) * sqrt( (R_1B*C_1T) / (R_1T*C_1B) ) * (.25 * ( X(1).^2) ) ...
         ) ...         
     + (R_1B/R_12) * (1 + R_2U/R_2L) * X(2) *.5 * ( ...
        w_1*sin(X(4) - X(3)) + w_2 * sqrt( (R_1T*C_1T) / (R_1B*C_1B) ) * cos( X(4)-X(3) )...
        );
 %amplitude of 2nd oscillator   
     w_2 * (X(2) / 2) * ( ...
         e_2g - (R_2B/R_21) * sqrt( (R_2T*C_2T) / (R_2B*C_2B) )...
         - ( 3*e_v*R_2U / R_2L) * sqrt( (R_2B*C_2T) / (R_2T*C_2B) ) * (.25 * ( X(2).^2) ) ...
         ) ...         
     + (R_2B/R_21) * (1 + R_1U/R_1L) * X(1) *.5 * ( ...
        w_2*sin(X(3) - X(4)) + w_1 * sqrt( (R_2T*C_2T) / (R_2B*C_2B) ) * cos( X(3)-X(4) )...
        );
  %phase of 1st oscillator  
    (1/X(1)) * ( ...
      w_1*X(1) + (R_1B*X(1)*w_1)/(R_12*2) ...
      + (R_1B/R_12)*(1 + R_2U/R_2L)*X(2)*.5 * (...
          w_2*sqrt( (R_1T*C_1T) / (R_1B*C_1B) ) * sin( X(4) - X(3) ) - w_1*cos( X(4) - X(3) ) )...
      );
  %phase of 2nd oscillator 
    (1/X(2)) * ( ...
      w_2*X(2) + (R_2B*X(2)*w_2)/(R_21*2) ...
      + (R_2B/R_21)*(1 + R_1U/R_1L)*X(1)*.5 * (...
          w_1*sqrt( (R_2T*C_2T) / (R_2B*C_2B) ) * sin( X(3) - X(4) ) - w_2*cos( X(3) - X(4) ) )...
      );
];
%Set Initial Conditions
c1 = .2;    %Amplitude of 1st oscillator at t=0
c2 = .201; %Amplitude of 2nd oscillator at t=0
c3 =  0;    %Phase of 1st oscil lator at t = 0
c4 =  3.1415;    %Phase of 2nd oscillator at t = 0
  
[t,xa] = ode15s(f,[0:.0000001: .05], [c1 c2 c3 c4]);

a1  = xa(:,1);  %amplitude of 1st oscillator
a2  = xa(:,2);  %amplitude of 2nd oscillator
th1 = xa(:,3);  %amplitude of 3rd oscillator
th2 = xa(:,4);  %amplitude ot 4th oscillator

delta_theta = th2-th1;

 figure 
plot(t,a1,t,a2)

  
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    