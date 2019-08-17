% Differential Equation Function: 
% Input differential equation for the ith oscillator here,


function [d_thetas] = theta_dot(thetas, omega_o, K,b,alpha,t )
  %thetas  = an NxN vector of phase variables
  %omega_o = vector of natural frequencies for phase oscillators
  %K       = coupling strength
  %b       = frequency strength parameter
  %t       = integration variable (not used in diffeq presently)
  
  %Calculate N
  N = numel(thetas(1,:));

  %Calculate Sum Vector that sums coupling from each oscillator 
  sum = sums(thetas,alpha);
  
  %Preallocate d_thetas data matrix
  %d_thetas = zeros(N,N,1);
  %{
  for i = 1:N
      for j = 1:N
          d_thetas(i,j,1) = omega_o(i,j).*(1 + b.*sin(2.*thetas(i,j))) + (K/N)*sum(i,j);
      end
  end
  %}
  
  d_thetas = omega_o.*(1 + b.*sin(2.*thetas)) + (K/N).*sum;
  

end