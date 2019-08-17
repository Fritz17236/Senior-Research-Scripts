function [ integral ] = Integrator( Vs,alpha,count,V_max,i,j,tau,dTau)
%INTEGRATOR Summary of this function goes here
%   Receives arguments from dK and returns function to be integrated
tilde_t   = count;             %t in timestep = count # from main calling function
tilde_tau = floor(tau/dTau);   %want tau in timesteps;

a  = Vs(i,tilde_t).*Vs(j,tilde_t-tilde_tau)./(V_max.^2);
b  = Vs(i,tilde_t-tilde_tau).*Vs(j,tilde_t)./(V_max.^2);
integral = H(tau,alpha).*a +H(-tau,alpha).*b;

end

