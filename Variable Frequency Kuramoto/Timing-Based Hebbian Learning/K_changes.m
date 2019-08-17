function [ changes_in_K, taus ] = K_changes( peaks,alpha,beta )
%K_changes receives (N,1)matrix of pulse times, and coactive learning parameter
%alpha.  It returns an NxN matrix of changes in K to be used for adjusting
%the coupling weights between two neurons
N = numel(peaks(:,1));
changes_in_K = zeros(N,N);
for i = 1:N
    for j = 1:N
        tau_ij  = peaks(i) - peaks(j);
        changes_in_K(i,j) = alpha*H(tau_ij,beta);
        taus(i,j) = tau_ij;
    end
end

