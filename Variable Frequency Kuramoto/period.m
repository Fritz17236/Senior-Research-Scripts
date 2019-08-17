function [ period ] = period( xa,dt )
%PERIOD function receives vector of thetas and timestep,dt. It calculates the average
%period of the set of coupled oscillators, this only applies to
%syncrhonized oscillators!! Otherwise the period is not well defined. 
%% 1. FFT to find fundamental period of the oscillation, Measure period inmultiples of the time step (Do we want to trim for specific frequencies?) 

%Parameters:
Fs        = 1/dt;            %Sampling Rate in Hz
xa        = mean( xa,1);     %Average along 25 oscillators, gives average phase 
V_real    = sin(xa);         %Real Signal from Vector
N         = length(V_real);      %Number of Data Points, should be EVEN

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


end

