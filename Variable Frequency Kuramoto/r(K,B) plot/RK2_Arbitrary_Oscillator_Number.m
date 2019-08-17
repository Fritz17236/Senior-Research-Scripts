%RK2 Kurmaoto Simulation
%close all
clear
clc
%simulation parameters
N = 250;   %Number of oscillators
K = 0;    %Global Coupling Strength
b = 0;   %Frequency Strength Paramter
db = .1; %Resolution for b variable
dK = .1; %Resolution for k variable
b_max =0;
K_max = .5;

r_Kb = zeros(floor(K_max/dK), floor(b_max/db));  %initialize data vector

for i = 1:(floor(K_max/dK))   %iterate through each K value
    for j = 1:floor(b_max/db); %iterate through each b value
        %run the oscillator simulation
        omega_o = normrnd(2*pi,.1,N,1);   %frequency for each oscillator
        init_thetas = normrnd(pi,5,N,1);  %initial phases
        f = @theta_dot;
        [t,xa] = ode15s(@(t,thetas) f(thetas,omega_o,K,b,t),[0:.01:10],init_thetas);
        xa = xa';
        %we want the time-averaged coherence for the last 5th of the time
        %vector
        T = numel(xa(1,:));
        r_Kb(i,j) = mean(coherence(xa(:,floor(.8*T):T)));   %store the coherence value in the r_Kb vector
        b = b + db;   %update the frequency strength parameter
    end
    K = K + dK;   %update the coupling strength
end






