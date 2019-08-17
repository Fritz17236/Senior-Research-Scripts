%Function K's receives Nx1 vector of oscillator phases,
% NxN vector of coupling strengths Kij, and learning parameters
% alpha and epsilon.  
%the function returns the derivative of the coupling strengths, Kij. 

function dKs = d_K(thetas,K,alpha,epsilon)
    N = numel(K(1,:));
    dKs = zeros(N,N);
    for i = 1:N
        for j = 1:N
            if K(i,j) > 1.1;
                disp('Something is wrong');
            end
            dKs(i,j) = epsilon*( alpha*cos(thetas(j)-thetas(i))- K(i,j) );
        end
    end
end
