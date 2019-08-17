function [ Resistance ] = R_2( R_20,V,b )
    %R_2 is the voltage-dependent resitance of Resistor R_2 for a
    %phenomenlogical constant, b. 
    N = numel(V);
    Resistance = zeros(1,N);
    for i = 1:N
    Resistance(1,i) = (R_20)*(1 + b * V(i).^2);
    end

end

