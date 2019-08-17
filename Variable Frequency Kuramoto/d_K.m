%Function K's receives Nx1 vector of oscillator phases,
% NxN vector of coupling strengths Kij, and learning parameters
% alpha and epsilon.  
%the function returns the derivative of the coupling strengths, Kij. 

function K_vector = d_K(thetas,K,alpha,epsilon)
    N = numel(K(1,:));
    K_vector = zeros(N,N);
    for i = 1:N
        for j = 1:N
            K_vector(i,j) = epsilon*(alpha*cos(thetas(i,1)-thetas(j))-K_vector(i,j));
        end
    end
end
