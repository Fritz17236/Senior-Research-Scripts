function [ d_Ks ] = dK( thetas,Ks,alpha,count,dt,V_max,SCALING )
%dK receives vector of phases, current coupling matrix Ks,
% and learning constant, alpha
%Function Parameters:
%dt argument input;
dTau = SCALING*dt;                  %integration resolution (width of reimann sum)
Tau_max = 70e-3;           %maximum integration time bound
N = numel(thetas(:,1));        %Number of oscillators

Vs = (V_max/2)*(1+sin(thetas));

%initialization
d_Ks       = zeros(N,N);    %initialize coupling matrix (this is the output)

for i = 1:N
    for j = 1:N %for each oscillator
        if i == j
            d_Ks(i,j) = 0; %keep diagonal elements at zero
        elseif  Ks(i,j) > 1
            d_Ks(i,j) = -1;
        elseif Ks(i,j) < -1
            d_Ks(i,j) = 1;
        else
            f = @(tau) Integrator( Vs,alpha,count,V_max,i,j,tau,dTau); %integrate over function
            d_Ks(i,j) = integral(f,0,Tau_max);     %store result in K(i,j) matrix;          
        
            
        end
    end
end
