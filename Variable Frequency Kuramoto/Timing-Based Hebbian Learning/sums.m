%Summing function for Kuramoto Oscillator System
%input is a vector of phase angles,
%output is a vector where each element i is the sum 
% SIGMA( sin(theta(j) - theta(i) ) for all j =\= i 

function [sum_vector] =sums(thetas,Ks)
% thetas = a vector of phase values

N = numel(thetas);        % there are N theta values
sum_vector = zeros(N,1);  % initialize vector containing their sums
for i = 1:N
    sum = 0;    %reset sum to 0
    for j = 1:N %for a particular oscillator j, 
        %sum the sine of phase difference between j and  every other oscillator k
        sum = sum + 1*( sin(thetas(j)-thetas(i)) );       
    end
    %store this sum in the sum vector
    sum_vector(i,1) = sum;
end
