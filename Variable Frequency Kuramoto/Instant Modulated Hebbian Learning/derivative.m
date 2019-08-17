



function [d_thetas, d_Ks] = derivative(thetas, omega_o, K,b,alpha,epsilon,t )
  %thetas  = a vector of phase variables
  %omega_o = vector of natural frequencies for phase oscillators
  %K       = coupling strength
  %b       = frequency strength parameter
  %t       = integration variable (not used in diffeq presently)

 N = numel(thetas);
 d_thetas = omega_o + omegas(thetas,b) + K/N * sums(thetas,K);
 %d_thetas= omega_o + omegas(thetas,b) - (K*coherence(thetas)-b)*sin(thetas);  

   d_Ks = zeros(N,N);
       for i = 1:N
           for j = 1:N
               d_Ks(i,j) = epsilon*(alpha*cos(thetas(i,1)-thetas(j))-d_Ks(i,j));
           end
       end      
end

    
    