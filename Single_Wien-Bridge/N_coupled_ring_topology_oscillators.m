% Matlab Code to Simulate a Single Wien-Bridge Oscillator for varying
% values of b, a phenomenological constant
clear
clc
%The equation has the form:
% V'' + (2 - R1/R2)V' + V = 0;
%R_2 = R_20 ( 1 + b V^2);

% The term (Vout_i+1 + Vout_i-1 ) is interpreted as 2* V_1 since there are
% only 2 oscillators, likewise with the prime terms (V_1' etc)


%% Physical Parameters
R_1  = 16e3;    %Upper Resistance (Ohms)
R_20 = 2.7e3;    %Lower Resitance  (Ohms)
b    = 25;      %Nonlinearity Parameter (Phenomenological Constant)
R_pos = 62e3;  %non_inverting coupling resistor (Ohms)
R_neg = 150e3; %inverting coupling resistor     (Ohms)
R     = 4.7e3;   %Filter circuit resistor (Ohms)

%%Simulation Parameters
T  = 500;    %Total time (s)
dt = 1e-3;  %Time Step (s)
N  = 32;     %Number of OscillatorsX(2);

%% Initialization
Rs =  normrnd(R,0,N,1);   %Normal Distribution of Rs mean frequencies

init_conds = normrnd(1, .05, 2*N,1); %random initial conditions for both voltages and their derivatives


%run the simulation
f = @(t,X) derivative(X,R_1,R_20,b,R_pos,R_neg,Rs,N,t) ;
    %Solver uses vector of derivates to find equation. 1st entry in vector
    %is variable, V, second is variable V', Since dV/dt = V', 1st entry is
    % variable to be solved for in the second place of the vector;
    %dV/dt = V'
    
[t,solns] = ode45(f,[0:dt:T], init_conds);
solns = solns';
for i = 1:2*N
    if mod(i,2) == 1; 
        index = round(i/2);
        Vs(index,:) = solns(i,:);
        norm_Vs(index,:) = Vs(index,:)./max(max(Vs(index,:)));
        
    else
        V_primes(i/2,:) = solns(i,:);
    end
end



%calculate  fundamental frequencies of each oscillator using Fourier
%Transform
Fs = 1/dt;            %sample rate of signal;
period = 1/Fs;        %sampling period
L  = T;               % Length of Signal
t_vec = (0:L-1)*T;    %Time Vector
f = Fs*(0:(L/2))/L;



clusterOne = zeros(N,T/dt+1);
clusterTwo = zeros(N,T/dt+1);

for i = 1:N
    Y(i,:) = fft(norm_Vs(i,:));
    P2 = abs(Y(i,:)./L);
    P1(i,:) = P2(1:L/2+1);
    [~, maxIndex(i)] = max(P1(i,:));
    freqs(i) = f(maxIndex(i));
    
    
    %extract phase using hilbert transformm
    complex_phase(i,:) = hilbert(norm_Vs(i,:));
    phases(i,:) = unwrap(angle(complex_phase(i,:)));
    
   
end

for i = 1:N
     if mod(i,2) ==1
    clusterOne(i,:) = norm_Vs(i,:);
    clusterTwo(i,:) = NaN;
    else 
    clusterTwo(i,:) = norm_Vs(i,:);
    clusterOne(i,:) = NaN;

    end
end

figure(3)
imagesc(norm_Vs)
figure(2)
plot((1:N),freqs,'.');
xlim([1 32]);
mean_freq = mean(mean(freqs,1));
ylim([.95*mean_freq 1.05*mean_freq]);
ylabel(' (Frequency (Hz))');
xlabel(' Oscillator Number ');

%r_movie(phases);

