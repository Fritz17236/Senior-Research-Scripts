%Order Paramter:  Function receives NxT vector containing
%phase versus time of N oscillaors and outputs the vector
%containing order parameter versus time

function [rs] = coherence(thetas)

N = numel(thetas(:,1));      %Determine How many oscillators there are:
t_max = numel(thetas(1,:));  %Determine how many timesteps there are:
rs = zeros(1,t_max);       %initialize rs vector
% for each time step
for t_count = 1:t_max
    
    %sum over each sine and cosine
    sine_sum   = 0;
    cosine_sum = 0;
 
    for i = 1:N
        sine_sum = sine_sum + sin(thetas(i,t_count));
        cosine_sum = cosine_sum + cos(thetas(i,t_count));
    end
    %calculate coherence and store in rs vector
    rs(1,t_count) = (1/(N))*sqrt( (cosine_sum).^2 + (sine_sum).^2);
    
    t_count = t_count + 1; %advance time
end