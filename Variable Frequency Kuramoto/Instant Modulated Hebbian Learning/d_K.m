%Function K's receives Nx1 vector of oscillator phases,
% NxN vector of coupling strengths Kij, and learning parameters
% alpha and epsilon.  
%the function returns the derivative of the coupling strengths, Kij. 

function dKs = d_K(thetas,K,alpha,epsilon,V_max)
    N   = numel(K(1,:));
    dKs = zeros(N,N);
    Vs  = (1+sin(thetas)).*(V_max/2);
    coeff = alpha/(V_max);
    for i = 1:N
        for j = 1:N
            if K(i,j) > 1.1;
                disp('Something is wrong');
            end
            dKs(i,j) = .10*(Vs(i)/V_max)*epsilon*( coeff*Vs(j)-K(i,j) );
            if i == j
                dKs(i,j) = 0;
            end
        end
    end
end
