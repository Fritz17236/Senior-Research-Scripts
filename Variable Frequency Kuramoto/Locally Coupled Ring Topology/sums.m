%Summing function for Kuramoto Oscillator System
%input is a vector of phase angles,
%output is a vector where each element i is the sum
% SIGMA( sin(theta(j) - theta(i) ) for all j =\= i

function [sum_vector] =sums(thetas,alpha)
% thetas = a vector of phase values

N = numel(thetas);        % there are N theta values
sum_vector = zeros(N,1);  % initialize vector containing their sums


%Nearest Neighbor Copuling, Ring Topology
for i = 1:N
    forward_sum = 0;
    back_sum  = 0;
    
    %if on first couple to last
    if i == 1
        forward_sum = forward_sum + sin(thetas(i+1) - thetas(1) -alpha);
        
        back_sum = back_sum + sin( thetas(N) - thetas(1) - alpha  );
        
        %if on last couple to first
    elseif i == N
        forward_sum = forward_sum + sin(thetas(1) - thetas(i)-alpha);
        
        back_sum = back_sum + sin( thetas(i-1) - thetas(i) -alpha  );
        
        
    else  %otherwise couple to adjacent oscillators
        forward_sum = forward_sum + sin( thetas(i+1) - thetas(i) -alpha);
        back_sum = back_sum + sin( thetas(i-1)  - thetas(i) -alpha);
    end
    
    sum_vector(i,1) = -(forward_sum-back_sum);
    %}
    
    
    %Global Coupling
    %{
for i = 1:N
    sum = 0;    %reset sum to 0
    for j = 1:N %for a particular oscillator j,
        %sum the sine of phase difference between j and  every other oscillator k
        sum = sum + sin(thetas(j)-thetas(i));
    end
    %store this sum in the sum vector
    sum_vector(i,1) = sum;
    
    
    %}
end

end
