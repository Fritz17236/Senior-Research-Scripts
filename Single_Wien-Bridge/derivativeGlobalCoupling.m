%Derivative function receives 2Nx1 vector which contains 2N variables, one for
%each oscillator and one for its derivative.  The function calculates the
%derivative of each variable and returns 2Nx1 vector of derviative values

function ds = derivativeGlobalCoupling(X,R_1,R_20,b,Rs,N,t)

%% Calculate Derivative for N Oscillators
ds = zeros(2*N,1);   %initialize vector containing derivatives


    for i = 1:2*N  %for each entry in derivative vector,
        
        if mod(i,2) == 1   %if on 1,3,5...etc,
          ds(i) = X(i+1);  %dV/dt_i = V'_i i.e derivative of V_i is V_i', the next entry in the vector
       
        else  %otherwise we are dealing with entry 2,4,6....2N, and so we calculate dV'/dt_i = V''_i
            index = round (i/2);
                ds(i) = -( 2 -  (R_1/R_2(R_20,X(1),b)))*X(i) - X(i-1);
        
        end
    end
end

  