%period finder for phase
function T = period(b,w,n)
T = (pi*(2*n + 1)/(w*sqrt(1-b.^2)));
end
