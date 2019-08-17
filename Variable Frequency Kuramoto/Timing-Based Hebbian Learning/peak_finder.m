%Peak Finder Function Receives an NxT funcion of oscillator phases. If the
%kth pulse occurs in oscillator N at phi = pi/2, and time t_Nk then the 
%peak finder function assigns the vector peaks(N,k) = t_Nk, where t_Nk = dt
%* i (timestep #) 

function [ peak] = peak_finder(thetas,dt)

N = numel(thetas(:,1));
T = numel(thetas(1,:));
peak = zeros(N,1);
pulse_found = false;
    for j = 1:N  %Move through each oscillator
        k = 1;   %Starting at k = 1,
        theta_o = thetas(j,1);
        for i = 1:T-1 %move through each calculated phase point in time
            curr_val = thetas(j,i);
            next_val = thetas(j,i+1);  
            
             if ( (curr_val <= (theta_o + pi/2 + 2*pi*(k-1)) ) && (next_val > ( theta_o + pi/2 + 2*pi*(k-1)) ) )
                %if the previous point was less than or equal to pi/2 + 2*pi*k,
                %and the next point is greater than, 2*pi*k,
                 peak(j,k) = i*dt;  %store the t_Nk, at the Nth oscillator and kth time point,
                 k = k + 1;  %update k to next index
                 pulse_found = true;
             end
         end
    end
%not every oscillator reaches the same number of pulses, i.e some reach
%reach 17, some reach 19, etc.  So, if a column in peaks(j,k) contains any
%zeros, this corresponds to no pulses occuring, and it will obscure the
%calculation of varians.  Therefore, we must find any columns with 0 and
%truncate the peaks vector afte the first such column. 
    if pulse_found
    trunc = 0;
        max_pulse_count = numel(peak(1,:));
        for i = 1:max_pulse_count
            if trunc == 0 
                for j = 1:N
                    if (peak(j,i) == 0) && (i > 1)
                        trunc = i;  %column # to truncate
                        break
                    end
                end
            end
        end

        if trunc ~= 0   %if there is bad data 
        peak = peak(:,1:trunc-1);  %truncate bad data 
        end
    else
        peak = zeros(N,1);
    end
end