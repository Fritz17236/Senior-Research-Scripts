function [ sync ] = sync( thetas )
%The sync function receives an NxT array of phases and calculates their 
%level of syncrhony at each point in time according to the equation
gamma = -1/(2*pi);

%initialization:
N = numel(thetas(:,1));
N_ITER = numel(thetas(1,:));
sync = zeros(1,N_ITER);

for i = 1:N_ITER
    sum = 0;
    mean_phase = mean(thetas(:,i));
    for j = 1:N
        delta_theta = abs(mean_phase - thetas(j,i) );
        sum = sum + delta_theta; 
    end 
    
    sync(1,i) = mean(thetas(:,i));%1 - (1/(2*pi*N))*sum;
    

end

