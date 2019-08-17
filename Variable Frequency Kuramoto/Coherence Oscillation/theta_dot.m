% Differential Equation Function: 
% Input differential equation for the ith oscillator here,


function [d_thetas] = theta_dot(thetas, omega_o, K,b,t )
  %thetas  = a vector of phase variables
  %omega_o = vector of natural frequencies for phase oscillators
  %K       = coupling strength
  %b       = frequency strength parameter
  %t       = integration variable (not used in diffeq presently)

  N = numel(thetas);
 d_thetas = omega_o + omegas(thetas,b) + K/N * sums(thetas);
 %d_thetas= omega_o + omegas(thetas,b) - (K*coherence(thetas)-b)*sin(thetas);  
end