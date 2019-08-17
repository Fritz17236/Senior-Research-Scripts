function d_thetas = theta_t(thetas,t,Kr,b,omega,Omega,psi)
%theta_t funcction receives input vector of thetas and returns vector of
%derivatives of theta
d_thetas = omega.*(1+b.*sin(thetas+psi)) ...
    - Kr.*sin(thetas) - Omega*(1 + b*sin(psi));
end