function [ pseudo_coherence ] = tightness( d_thetas,omega )
%Tighntess receives an NxT Vector of phases, and returns a 1xT vector
%specifying the "tightness" of these equations. The metric for tightness is
%the deviation of frequencies. 

N = numel(d_thetas(:,1));
T = numel(d_thetas(1,:));

means = mean(d_thetas,2);

    curr_sum = 0;
    
    pseudo_coherence = 1 - var(means)/omega;
end