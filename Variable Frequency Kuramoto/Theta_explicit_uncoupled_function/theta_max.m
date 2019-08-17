function [ theta ] = theta_max( Kr,b,omega,h )
%function determines maximum theta value during mean phase pulse
 A = Kr/b;
 B = (omega*b - h)/(b*omega+b*h);
 C =  sqrt(A.^2 + B^2 +1);
 
 theta = 2*atan( (C - A)/(B+1) );

end

