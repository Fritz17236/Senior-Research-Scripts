% Differential Equation Function: 
% Input differential equation for the ith oscillator here,


function [d_thetas] = theta_dot(thetas, omega_o, Ks,b)
  %thetas  = a vector of phase variables
  %omega_o = vector of natural frequencies for phase oscillators
  %K       = coupling strength
  %b       = frequency strength parameter
  %t       = integration variable (not used in diffeq presently)
 N = numel(thetas);
 sum = sums(thetas,Ks);
 d_thetas = omega_o.*(1  +  b.*sin(thetas))  + (1/N).*sum;
end