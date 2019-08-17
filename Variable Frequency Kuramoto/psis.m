%Psi function receives NxT vector of phases and computes a 1xT vector
%corresponding to the mean phase:
% psi = arcsin(  1/(rN)  * SIGMA(  sin (theta_j) ) for j = 1...N

function [psi_vector, cos_vec] = psis(thetas)
T = numel(thetas(1,:));  %compute the length in timesteps of the vector
N = numel(thetas(:,1));  %compute the number of oscillators in the vector


%initialize psi vector
psi_vector = zeros(1,T);

    for k = 1:T
        
        r = 1;% coherence(thetas(:,k));  %compute order parameter
        sine_sum = 0;
        cos_sum  = 0;
        for j = 1:N  %sum over sines of each oscillator phse
            sine_sum = sine_sum + sin((thetas(j,k)));
            cos_sum  = cos_sum  + cos((thetas(j,k)));
        end
        psi_vector(1,k) =   (((1/(r*N)) * sine_sum)); 
        cos_vec(1,k)    =   ((1/(r*N)) * cos_sum);
    end
end

