%Summing function for Kuramoto Oscillator System
%input is a vector of phase angles,
%output is a vector where each element i is the sum 
% SIGMA( sin(theta(j) - theta(i) ) for all j =\= i 

function [sum_vector] =sums_matrix(thetas)
% thetas = a vector of phase values

    N = numel(thetas(:,1));        % there are NXN theta values
    sum_vector = zeros(N,N);  % initialize vector containing their sums
    for i = 1:N
        for j = 1:N %for each oscillaotr 
            sum = 0; %set sum to 0
            for k = 1:N
                for l = 1:N
                sum = sum + (sin(thetas(k,l)) - sin(thetas(i,j)) ) ;
                end
            end
            sum_vector(i,j) = sum;
        end    
    end
end