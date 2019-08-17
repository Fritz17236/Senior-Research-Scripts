function [r2,dr2]=r2fb(u,b,R20 )

%it returns the value of R2=r2 and its derivative dr2=dR2/dVi
%u(i)=Vi (the voltage values)

r2=R20*(1+b*u.^2);
dr2=2*R20*b.*u;
end