function [ d_Ks ] = dK( thetas,alpha,count,dt )
%dK receives vector of phases, current coupling matrix Ks,
% and learning constant, alpha
%Function Parameters:
%dt argument input;
dTau = dt;                  %integration resolution (width of reimann sum)
Tau_max = 50e-3;           %maximum integration time bound
N = numel(thetas(:,count));          %Number of oscillators
N_Sum = round(Tau_max/dTau);%Integration bound

%initialization
d_Ks       = zeros(N,N);    %initialize coupling matrix (this is the output)


for i = 1:N
    for j = 1:N %for each oscillator
        integ_sum  = 0;             %initialize integration sum to 0
        tilde_t   = count;          %t in timestep = count # from main calling function
        tau       = 0;              %set tau = 0; 
        tilde_tau = (tau/dTau);     %want tau in timesteps;
        
        for k = 1:N_Sum %integrate timing correlation function over Tau
            a  = (1+sin(thetas(i,tilde_t)))*(1+ sin(thetas(j,tilde_t-tilde_tau)));
            b  = (1+sin(thetas(i,tilde_t-tilde_tau)))*(1+ sin(thetas(j,tilde_t)));
            f = H(tau,alpha)*a +H(-tau,alpha)*b;
            
          integ_sum = integ_sum + dTau*f;    
          tau       = tau + dTau;
          tilde_tau = round(tau/dTau);
        end
        d_Ks(i,j) = integ_sum;  %store result in K(i,j) matrix;
    end
end
