%Order Paramter:  Function receives NxT vector containing
%voltages versus time of N oscillaors and outputs the vector
%containing order parameter versus time

function [rs] = synchrony(Vs)

N = numel(Vs(:,1));      %Determine How many oscillators there are:
t_max = numel(Vs(1,:));  %Determine how many timesteps there are:
rs = zeros(1,t_max);       %initialize rs vector
V_max = max(max(Vs));
% for each time step
for t_count = 1:t_max
    %calculate coherence and store in rs vector
    rs(1,t_count) = 1 - (1./(N*V_max))*std(Vs(:,t_count));
end