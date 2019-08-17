function [ delta_r ] = delta_r( omega,b,omega_o,K)
%delta r computes the change in coherence as a function of K,r, b, omega,
r =1;%and the perturbations delta_j

psi_max = pi/2;%acos( (K*r)/(omega*b) );
N = numel(omega_o);
etas = omega_o - omega;

coeff = 1/N;

sum = 0;
for i = 1:N
    theta_max = etas(i)*(1+b);
sum = sum + exp(1i*(theta_max));
end

delta_r =  abs(coeff*sum);

end

