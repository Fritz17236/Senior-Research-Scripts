%Derivative function receives 2Nx1 vector which contains 2N variables, one for
%each oscillator and its derivative.  The function calculates the
%derivative of each variable and returns 2Nx1 vector of derviative values

function ds = derivative(X,N,C,R,R_1,R_2,R_pos,R_neg,e_v)

%% Calculate Derivative for N Oscillators
ds = zeros(2*N,1);
    for i = 1:2*N
        if mod(i,2) == 1 
          ds(i) = X(i+1);        
        elseif i == 2*N; %if we are on the last oscillator
            R_i_mod = (1-e_v*(X(i-1).^2));
            R_j_mod = (1-e_v*(X(1).^2));
            if R_i_mod < 0
                R_i_mod = 0;
            end
            if R_j_mod < 0
                R_j_mod = 0;
            end
               ds(i) = -1/(C*R)*(...
        X(i)*( 2 - ((R_1/R_2)*R_i_mod) + (R/R_pos) - (R_1/R_neg)*R_i_mod  ...
            +   ((R*R_1)/(R_pos*R_neg)) *R_j_mod )  ...
        + X(2)*( ((R_1/R_neg)*R_i_mod ) - (R/R_pos) +  ( ((R_1.^2)/(R_2*R_neg)) * (R_j_mod.^2 ) )...
            - ((R_1*R)/(R_2*R_pos))*R_j_mod - ((R_1*R)/(R_pos*R_neg))*R_j_mod )...
         +(1/C)*( X(i-1)*( (1/R) + (1/R_pos) + (R_1/(R_pos*R_neg))*R_j_mod) ...
            - X(1)*( (1/R_pos) + (R_1/(R_2*R_pos))*R_j_mod+ (R_1/(R_pos*R_neg))*R_j_mod ) )...
            );
        else
            
            R_i_mod = (1-e_v*(X(i-1).^2));
            R_j_mod = (1-e_v*(X(i+1).^2));
            if R_i_mod < 0
                R_i_mod = 0;
            end
            if R_j_mod < 0
                R_j_mod = 0;
            end
              ds(i) = -1/(C*R)*(...
        X(i)*( 2 - ((R_1/R_2)*R_i_mod) + (R/R_pos) - (R_1/R_neg)*R_i_mod  ...
            +   ((R*R_1)/(R_pos*R_neg)) *R_j_mod )  ...
        + X(i+2)*( ((R_1/R_neg)*R_i_mod ) - (R/R_pos) +  ( ((R_1.^2)/(R_2*R_neg)) * (R_j_mod.^2 ) )...
            - ((R_1*R)/(R_2*R_pos))*R_j_mod - ((R_1*R)/(R_pos*R_neg))*R_j_mod )...
         +(1/C)*( X(i-1)*( (1/R) + (1/R_pos) + (R_1/(R_pos*R_neg))*R_j_mod) ...
            - X(i+1)*( (1/R_pos) + (R_1/(R_2*R_pos))*R_j_mod+ (R_1/(R_pos*R_neg))*R_j_mod ) )...
            );
        end
    end
end

  