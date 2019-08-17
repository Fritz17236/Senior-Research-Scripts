function [ H_Tau ] = H( Tau,beta )
%H function is the pre/postsynaptic modification rate, For positive Tau, 
% H returns negative value depending on magnitude of Tau implying
% oscillator j's activity is before or after oscillator i's.  This
% determines whether Long-Term  Potentiation or Long-Term Depression is
% Occuring. (LTD or LTP). 
     %time constant (s^-1);
    length = numel(Tau);
    H_Tau = zeros(1,length);
    for i = 1:length
        elem = Tau(i);
        if elem > 0
            H_Tau(i) = exp(-elem.*beta);
        elseif elem < 0     
            H_Tau(i) = -exp(elem.*beta);
        elseif elem == 0
            H_Tau(i) = 0;
        end

    end

end
