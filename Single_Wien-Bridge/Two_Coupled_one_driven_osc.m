% Matlab Code to Simulate a Single Wien-Bridge Oscillator for varying
% values of b, a phenomenological constant

clear
clc
%The equation has the form:
% V'' + (2 - R1/R2)V' + V = 0;
%R_2 = R_20 ( 1 + b V^2);

% The term (Vout_i+1 + Vout_i-1 ) is interpreted as 2* V_1 since there are
% only 2 oscillators, likewise with the prime terms (V_1' etc)


%Physical Parameters
R_1  =6e3;    %Upper Resistance (Ohms)
R_20 = 2.7e3;    %Lower Resitance  (Ohms)
b    = 9;      %Nonlinearity Parameter (Phenomenological Constant)
R_pos = 62e3;  %non_inverting coupling resistor (Ohms)
R_neg = 62e3; %inverting coupling resistor     (Ohms)
R     = 4.7e3;   %Filter circuit resistor (Ohms)

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
    ...
    %Now for the Second, Driven Oscillator
    X(4);
    ...
    %Eq 2:
    -(  2 -  ( R_1 / R_2(R_20,X(3),b)  ) - ((2*R_1) / (R_neg)) + ((2*R) / (R_pos)) )*X(4) ...
        - (1 + (2*R) / (R_pos) )*X(3) + (R / R_pos)* (X(1)+X(1))  ...
        - (  (R_1 / R_neg) - (R / R_pos) ) * ( X(2) + X(2) )
    ];

[t,solns] = ode45(f,[0 T], [0 1 0 0]);
solns = solns';
V_driver = solns(1,:);
V_driven = solns(3,:);
%legend('Driving Oscillator','Driven Oscillator');


%Now calculate the phase shift between the signals and store it
complex_driver = hilbert(V_driver);
complex_driven = hilbert(V_driven);

driver_phase   =  unwrap( angle(complex_driver) );
driven_phase   =  unwrap( angle(complex_driven) );

phase_delay = (mean( (driver_phase - driven_phase)));

figure(1)
plot(t,V_driver,t,V_driven);
legend('Driver','Driven');

 txt = strcat('Phase delay is: ',num2str(phase_delay));
text( max(t)/2,max(V_driver),txt);




