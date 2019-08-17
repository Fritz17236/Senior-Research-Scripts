function [ sync ] = sync( thetas )
%The sync function receives an NxT array of phases and calculates their 
%level of syncrhony at each point in time according to the equation:
%s(t) = 1/N * SUM(   exp( i    exp(gamma*delta_phi_ij)  )  )
%paramters:
gamma =  -1;   %synchrony kernel parameter

%initialization:
N = numel(thetas(:,1));
N_ITER = numel(thetas(1,:));

for i = 1:N_ITER
    sum = 0;
    mean_phase = mean(thetas(:,i));
    for j = 1:N
        delta_theta = abs(mean_phase - thetas(j,i) );
        if delta_theta <= pi;
            sum = 0;
        else
        sum = sum + exp(gamma*delta_theta); 
        end
    end 
    
    sync(1,i) = 1- (1/N)*sum;


end

