function [d_thetas] = theta_dot(thetas, omega_o, K,b,t )
  %thetas  = a vector of phase variables
  %omega_o = vector of natural frequencies for phase oscillators
  %K       = coupling strength
  %b       = frequency strength parameter
  %t       = integration variable (not currently used in diffeq)
  
  %There are N Oscillators
  N = numel(thetas(1,:));
 
  %Initialize d_thetas vector
  d_thetas = zeros(N,N,1);
  
  
  %Create sum vector containing sum of each oscillator
  sum_vec = sum_generator(thetas);
  for i = 1:N
     for j =1:N
     d_thetas(i,j) = omega_o(i,j).*(1  +  b.*sin(thetas(i,j)))  + (K/8).*sum_vec(i,j); 
     end
  end

end