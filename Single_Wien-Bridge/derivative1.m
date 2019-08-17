%Derivative function receives 2Nx1 vector which contains 2N variables, one for
%each oscillator and one for its derivative.  The function calculates the
%derivative of each variable and returns 2Nx1 vector of derviative values

function ds = derivative1(X,R_10,R_2,b,R_pos,R_neg,Rs,N,t)

%% Calculate Derivative for N Oscillators
ds = zeros(2*N,1);   %initialize vector containing derivatives


    for i = 1:2*N  %for each entry in derivative vector,
        
        if mod(i,2) == 1   %if on 1,3,5...etc,
          ds(i) = X(i+1);  %dV/dt_i = V'_i i.e derivative of V_i is V_i', the next entry in the vector
          
        elseif i == 2   %if we are on the first oscillator, couple to the last
          index = 1;  %this is the oscillator number
                ds(i) = -(  2 -  ( R_1(R_10,X(i-1),b) / R_2  ) - (2*R_1(R_10,X(i-1),b)) / (R_neg) + (2*Rs(index)) / (R_pos) )*X(i) ...
        - (1 + (2*Rs(index)) / (R_pos) )*X(i-1) + (Rs(index) / R_pos)* (X(i+1)+X(2*N-1))  ...
        - (  (R_1(R_10,X(i-1),b) / R_neg) - (Rs(index) / R_pos) ) * ( X(i+2) + X(2*N) );
            
        elseif i == 2*N %if we are on the last oscillator, couple it to the first
            index = N;
                ds(i) = -(  2 -  ( R_1(R_10,X(i-1),b) / R_2  ) - (2*R_1(R_10,X(i-1),b)) / (R_neg) + (2*Rs(index)) / (R_pos) )*X(i) ...
        - (1 + (2*Rs(index)) / (R_pos) )*X(i-1) + (Rs(index) / R_pos)* (X(1)+X(i-3))  ...
        - (  (R_1(R_10,X(i-1),b) / R_neg) - (Rs(index) / R_pos) ) * ( X(2) + X(i-2) );
             
        else  %otherwise we are dealing with entry 2,4,6....2N, and so we calculate dV'/dt_i = V''_i
            index = round (i/2);
                ds(i) = -(  2 -  ( R_1(R_10,X(i-1),b) / R_2  ) - (2*R_1(R_10,X(i-1),b)) / (R_neg) + (2*Rs(index)) / (R_pos) )*X(i) ...
        - (1 + (2*Rs(index)) / (R_pos) )*X(i-1) + (Rs(index) / R_pos)* (X(i+1)+X(i-3))  ...
        - (  (R_1(R_10,X(i-1),b) / R_neg) - (Rs(index) / R_pos) ) * ( X(i+2) + X(i-2) );
        end
    end
end


  