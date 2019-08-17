function phi = phi_t(t,b,w)
phi_0 = 1.5*pi
beta = sqrt(1 - b.^2);
C = (-2/ sqrt(1-b^2)) * atan( (b+tan(phi_0*.5) )/sqrt(1-b^2));
phi =  2*atan(  beta* tan( ((w*t-C)*beta/2 )  ) -b ) ;
end
