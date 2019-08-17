function [ primes ] = V_outPrime( c,A_inv,V_inPrime,R_1,V_in, R_20,b)
%This implements equation six in the Experimental Chimera paper
%For each oscillator i in the ring
N = numel(V_in);
primes = zeros(1,N);
R_Two = R_2(R_20,V_in,b);
    for i = 1:N
        sumOne = 0;
        sumTwo = 0;
        
        %Generate First Sum
        for j = 1:N
            sumOne = sumOne + A_inv(i,j)*V_inPrime(j);
        end

        %Generate Second Sum
        for j = 1:N
            sumTwo = sumTwo + A_inv(i,j)*V_in(j);
        end

        %Calculate result          %R1/R2^2                   *  dR_2/dV_i
        primes(i) = c(i)*sumOne - ( R_1/ (R_Two(i).^2) )* (2 * R_20 * V_in(i)*b) ...
            * sumTwo*V_inPrime(i);
               
    end
end

