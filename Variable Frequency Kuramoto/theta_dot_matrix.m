% Differential Equation Function: 
% Input differential equation for the ith oscillator here,


function [d_thetas] = theta_dot_matrix(thetas, omega_o, K,b,t )
  %thetas  = a vector of phase variables
  %omega_o = vector of natural frequencies for phase oscillators
  %K       = coupling strength
  %b       = frequency strength parameter
  %t       = integration variable (not used in diffeq presently)
  N = numel(thetas(:,:,1));
 sum = sums_matrix(thetas(:,:,1));
 d_thetas = omega_o.*(1  +  b.*sin(2.*thetas))  + (K/N).*sum;

 %d_thetas= omega_o + omegas(thetas,b) - (K*coherence(thetas)-b)*sin(thetas);  
end