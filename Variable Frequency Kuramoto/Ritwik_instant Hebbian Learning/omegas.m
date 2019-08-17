function [ omegas ] = omegas( thetas, b )
%Phase Dependent Frequency Function
% thetas = a single value or a vector of phase values
% b      = a single value specifying magnitude of frequency
omegas = b*(sin(thetas));
end

