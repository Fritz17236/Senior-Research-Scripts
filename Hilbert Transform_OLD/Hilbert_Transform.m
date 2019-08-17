function [ reduced_phase ] = Hilbert_Transform( input )
%HILBERT_TRANSFORM



%The "phase oscillator hilbert" function does the following:
%% 1. FFT to find fundamental period of the oscillation, Measure period inmultiples of the time step (Do we want to trim for specific frequencies?) 

%Parameters:
Fs        = 1000;               %Sampling Rate in Hz
V_real    = input;              %Real Signal from Vector
N         = length(input);      %Number of Data Points, should be EVEN

%For Debugging:



%Make signal of even length
if rem(length(V_real), 2) == 1    %If input signal is not even length, 
    V_real = V_real(1:end-1);     %truncate first data point in order to reach even length
end
N         = length(V_real);       %Number of data points is now even

X  = fft(V_real,N);                     %Fourier Transform that produces double sided spectrum (positive and negative frequencies)
P2 = sqrt(real(X).^2 + imag(X).^2)/N;   %Want Magnitude of Freqencies, this gives two sided spectrum
P1 = P2(1:N/2+1);                       %Want only One Side of Spectrum
P1 = 2*P1;                              %We double because the real magnitude is only half of the fft calculated magnitude (its complex and we took the real part)
[~, freq_index] = max(P1);              %Max value is one, but max values is stored at (Frequency index) location in array
f  = Fs*(0:(N/2))/N;                    %Generate Frequency Vector ranging from 0 to Nyquist Frequency (Fs/2)
period = 1/f(freq_index);               %We now have the largest fundamental period 
period_idx = round(period*Fs);          %Want period in multiples of time step                                        %step 
%%
%% 2. Identify where the signal first crosses zero with positive slope. Call this "trigger". Discard data beforehand.

trigger_index = -1;                       %if no crossing, index = -1 for debugging
for i = 2:period_idx*2                    %iterate through each data point ( must start at 2nd point)
    if V_real(i+1) > 0 && V_real(i-1) < 0 %if i+1 >0 and i-1 < 0, then positive crossing occured at i.
        trigger_index = i;                %i is now the index of the trigger (indexing the variable 'input') 
        break                             %End loop now that we have the first trigger point
    end
end

if trigger_index == -1
        disp('No trigger vay lue found');   %Debug Message
end   

V_real = V_real(trigger_index:end);             %Discard data before trigger.
imaginary = zeros(1,length(V_real));              %Our output imaginary vector should have same length as trimmed input vector
%%

%% 3. Find left max (within 1/2 period of trigger) and left min(between 1/2 period and full period after trigger).

[l_max, l_max_index] = max( V_real( 1 : 1+round(period_idx/2) ) );             %maximum value and its index within half period of trigger (now beginning of vector)
[l_min, l_min_index] = min( V_real( 1+round(round(period_idx/2)) : 1+period_idx ) );  %minimum value and its index between half and full period of trigger (now beginning of vector)
l_min_index = l_min_index + 1 + round(period_idx/2);                            %max function gives index relative to slice, must add index corresponding to starting index of slice to compensate
%%
%% Now we begin the loop:

while (1)     %iterate until exit condition is explicitly reached
   
    if l_min_index+period_idx >= length(V_real)   %If we cannot fit another full period to the data set,
    print('Done')
    
        break                                     %Break the loop
    end

    %Find The Trigger following the first full period (start searching at l_min_index)
        trigger_index = -1;                       %if no crossing, index = -1 for debugging
    for i = l_min_index:l_min_index+period_idx    %iterate through each data point ( must start at 2nd point)
        if V_real(i+1) > 0 && V_real(i-1) < 0     %if i+1 >0 and i-1 < 0, then positive crossing occured at i.
            trigger_index = i;                    %i is now the index of the trigger (indexing the variable 'input') 
            break           
            %End loop now that we have the first trigger point
        end
    end

    if trigger_index == -1
            disp('No trigger value found');   %Debug Message
    end

    %% 4. Find right max and right min.
    
    if trigger_index + period_idx >= length(V_real)  %If we cannot fit another full period to the data set,
            break                                        %Break the Loop
    end
    [r_max, r_max_index] = max(V_real( trigger_index : trigger_index+round(period_idx/2) ) );  %maximum value and its index within half period of trigger
    [r_min, r_min_index] = min( V_real( trigger_index+round(period_idx/2) : trigger_index+period_idx ) );  %minimum value and its index between half and full period of trigger

     r_max_index = r_max_index + trigger_index;            %previous value is relative to trigger, so it is necessary to compensate
     r_min_index = r_min_index + trigger_index + round(period_idx/2); %similarly, but relative to trigger + 1/2 period.
    %%

    

    %% 5. Normalize downward portion of real data, and compute imaginary as sqrt(1 - x**2)
   if V_real(l_min_index) == V_real(l_min_index+1)    %Its possible two values in a row have the same max/min
      l_min_index = l_min_index + 1;                 %move to next index to capture latter max/min
  end
  
  left_mean = (l_min + l_max)/2;            %calculate mean for left end
  left_amp  = (l_min - l_max)/2;            %calculate amplitude for left end

  mid_mean  = (r_max + l_min)/2;            %Mean of middle Section
  mid_amp   = (r_max - l_min)/2;            %Amplitude of Middle Section
  
  values = V_real(l_min_index:r_max_index); %Values along this slice of data
  n = length(values);                       %Length of data slice
  
  means = [0:n-1]* (mid_mean-left_mean)/(n-1) ; %Create vector of evenly spaced means going from l_mean to r_mean
  means(1) = left_mean;                       %add l_mean to means so vector goes from l_mean evenly to r_mean
  values = values - means;                    %subtract means from values
  
  amps = [0:n-1]* (mid_amp-left_amp)/n-1;     %likewise with amplitudes
  horzcat(left_amp, amps);
  values = values/amps;                     %except we divide by amplitude to normalize
  imaginary(l_min_index:r_max_index) = sqrt(1-values.^2);  %now calculate imaginary values
    %%
  
    %% 6. Smooth imaginary near x = +-1
    % Will smooth here
    %%

    
  
  
    %% 7. Normalize upward portion of real data, compute imaginary.
  if V_real(l_min_index) == V_real(l_min_index+1)    %Its possible two values in a row have the same max/min
      l_min_index = l_min_index + 1;                 %move to next index to capture latter max/min
  end
  
  right_mean = (r_min + r_max)/2;            %calculate mean for right end
  right_amp  = (r_max - r_min)/2;            %calculate amplitude for right end

  
  values = V_real(l_min_index:r_max_index); %Values along this slice of data
  n = length(values);                       %Length of data slice
  
  means = [0:n-1]* (mid_mean-left_mean)/(n-1) ; %Create vector of evenly spaced means going from l_mean to r_mean
  horzcat(left_mean,means);                      %add l_mean to means so vector goes from l_mean evenly to r_mean
  values = values - means;                    %subtract means from values
  
  amps = [0:n-1]* (mid_amp-left_amp)/n-1;     %likewise with amplitudes
  horzcat(left_amp, amps);
  values = values/amps;                     %except we divide by amplitude to normalize
  imaginary(l_min_index:r_max_index) = sqrt(1-values.^2);  %now calculate imaginary values
    %%
  
  
    %% 8. Smooth imaginary near x = +- 1
    %Will smooth here
    %%
   
    %% 9. Multiply imaginary by -1
    imaginary = imaginary*-1;
    %%
    
    %% 10. Cycle triggers, go to #4.
    l_max = r_max;
    l_max_index = r_max_index;
    l_min = r_min;
    l_min_index = r_min_index;
    %%
end
    reduced_phase = imaginary;
end

