function [ derivative ] = d_theta_d_eta( b, Kr, Omega, eta, theta, psi )
%Function receives parameters b, Kr, Omega, psi; and 
%variables theta,eta.
top = - (1 + b*sin(theta+psi));
bottom = b*cos(psi + theta) * (Omega+eta) - Kr*cos(theta);
derivative = top/bottom;

end

