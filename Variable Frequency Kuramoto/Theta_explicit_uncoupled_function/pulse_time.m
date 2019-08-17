%period finder for phase
function T_k = pulse_time(b,w,k)
beta = sqrt( 1-b.^2);
C = (-2/ sqrt(1-b^2)) * atan( (b-1)/sqrt(1-b^2));
T_k = (  2/(w*beta) ) *(  atan( (1+b)/beta ) + pi*k) + C/w;
end
