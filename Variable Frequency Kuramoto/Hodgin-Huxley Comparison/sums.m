%Summing function for Kuramoto Oscillator System
%input is a vector of phase angles,
%output is a scalar represening the sum
% SIGMA( (V(j) - V(i) ) for all j =\= i 

function [sum] =sums(Vs)
% Vs = a vector of voltage values

    N = numel(Vs);        % there are N theta values
    for i = 1:N
        sum = 0;    %reset sum to 0
        for j = 1:N %for a particular oscillator j,
                    sum = sum + sin(((Vs(j)-Vs(i))));       
            %sum the sine of phase difference between j and  every other oscillator k
        end

    end
end
