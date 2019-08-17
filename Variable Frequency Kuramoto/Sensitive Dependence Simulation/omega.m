function [ omegas ] = omega( thetas, b )
%Phase Dependent Frequency Function
% thetas = a single value or a vector of phase values
% b      = a single value specifying magnitude of frequency
omegas = b*(cos(thetas).^5);
end

