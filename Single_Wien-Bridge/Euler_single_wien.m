
%% Matlab Code to Simulate an Euler step Wien-Bridge Oscillator Ring
close all
clear
clc



%% Physical Parameters
R_1  =9e3;       %Upper Resistance (Ohms)
R_20 = 2.7e3;    %Lower Resitance  (Ohms)
b    = 5;        %Nonlinearity Parameter (Phenomenological Constant)
R_pos = 62e3;    %Non-Inverting coupling resistor (Ohms)
R_neg = 100e3;    %Inverting coupling resistor     (Ohms)
R     = 4.7e3;   %Filter circuit resistor         (Ohms)

%% Simulation Parameters
T  = 500;    %Total time (s)
dt = 1e-4;   %Time step (s)
N = 32;      %Number of Oscillators in Ring


%% Initialization:
ts = zeros(1,T/dt);             %Time Vector
U = zeros(N,T/dt);              %V' Vector ;dV/dt
Q = zeros(N,T/dt);              %V vector ; V(t)
V_outs = zeros(N,T/dt);         %Tranfsformed V(t)
V_outPrimes = zeros(N,T/dt);    %Transformed dV/dt  
t = 0;                          %Initialize time to 0
count = 1;                      %Iteration Count

Q(:,1) = 2*rand(N,1)-1;     %Random Initial Voltages

%% Calculate decay parameters for Coupling Kernel
gamma = R_1/R_neg;
kappa = acosh(1/(2*gamma));




%% Calculate the Inverse Matrix and associated transformation


for i = 1:N
    for j = 1:N
           A_inv(i,j) = -1^(i+j)*(1/gamma)*exp(-kappa*i); 
    end
end

A = zeros(N,N);
for i = 1:N
    for j = 1:N
        if i==j
            A(i,j) = 1;
        end
        if j==i+1 || j==i-1
            A(i,j) = gamma;
        end
        if i ==N && j == 1
            A(i,j) = gamma;
        end
        if i == 1 && j == N
            A(i,j) = gamma;
        end
    end
end


A_inv = inv(A);




%% Run the simulation

%Second order DEQ is split into two solution vectors, U,Q, for V' and
%V respectively. 
 while t < T
    
    %Clear Derivative Vectors
    dU = zeros(1,N);
    dQ = zeros(1,N);
    
    %Calculate V_outs and their derivatives
    c(:) = 1 + (R_1./R_2(R_20,Q(:,count),b)) + 2*(R_1/R_neg);
    V_outs(:,count+1) = c(:).*(A_inv*Q(:,count));
    V_outPrimes(:,count+1) = V_outPrime(c(:) ,A_inv,U(:,count),R_1,Q(:,count),R_20,b);
    
    for i = 1:N
    %Calculate the dU vector (associated with dV'/dt)

        if i == 1 %If on the first oscillator, link to the last
        dU(i) = -(  2 -  ( R_1 / R_2(R_20,Q(i,count),b)  ) - (2*R_1) / (R_neg) + (2*R) / (R_pos) )*U(i,count) ...
            - (1 + (2*R) / (R_pos) )*Q(i,count) + (R / R_pos)* ( V_outs(i+1,count) +V_outs(N,count) ) ...
            - (  (R_1 / R_neg) - (R / R_pos) ) * ( V_outPrimes(i+1,count) +V_outPrimes(N,count) );

        dQ(i) = U(i,count);

        

        elseif i == N %If on the last oscillator, link to the first

        dU(i) = -(  2 -  ( R_1 / R_2(R_20,Q(i,count),b)  ) - (2*R_1) / (R_neg) + (2*R) / (R_pos) )*U(i,count) ...
            - (1 + (2*R) / (R_pos) )*Q(i,count) + (R / R_pos)* ( V_outs(1,count) +V_outs(i-1,count) ) ...
            - (  (R_1 / R_neg) - (R / R_pos) ) * ( V_outPrimes(1,count) +V_outPrimes(i-1,count) );

        dQ(i) = U(i,count);

        else
                %Else link to oscillator in front and back
        dU(i) = -(  2 -  ( R_1 / R_2(R_20,Q(i,count),b)  ) - (2*R_1) / (R_neg) + (2*R) / (R_pos) )*U(i,count) ...
            - (1 + (2*R) / (R_pos) )*Q(i,count) + (R / R_pos)* ( V_outs(i+1,count) +V_outs(i-1,count) ) ...
            - (  (R_1 / R_neg) - (R / R_pos) ) * ( V_outPrimes(i+1,count) +V_outPrimes(i-1,count) );

        dQ(i) = U(i,count);


        end

    end
    
    %Record Values
    U(:,count+1)  = U(:,count)+dt*dU';
    Q(:,count+1)  = Q(:,count)+dt*dQ';
    if max(Q(:,count+1)) > 10
        break;
    end
    
    %record time
    ts(1,count+1) = t;
    
    
    %update indices
    count = count + 1;
    t  = t + dt;
end

for i = 1:N
    norm_V(i,:) = Q(i,:)/max(Q(i,:));
end


%% Calculate  fundamental frequencies of each oscillator using Fourier Transform
Fs = 1/dt;            %Sample rate of signal;
period = 1/Fs;        %Sampling period
L  = T;               %Length of Signal
t_vec = (0:L-1)*T;    %Time Vector
f = Fs*(0:(L/2))/L;   %Frequency Vector


for i = 1:N  %For each oscillator
    Y(i,:) = fft(norm_V(i,:));       %Computer Fast Fourier Transform
    P2 = abs(Y(i,:)./L);             %Want Real Magnitude
    P1(i,:) = P2(1:L/2+1);           %Take only positive half of frequencies
    [~, maxIndex(i)] = max(P1(i,:)); %Locate the maximum strength Frequency
    freqs(i) = f(maxIndex(i));       %Store this frequency
    
    %Extract phase using Hilbert transformm
    complex_phase(i,:) = hilbert(norm_V(i,:));
    phases(i,:) = unwrap(angle(complex_phase(i,:)));    
end

%% Analyze and Plot Data

%Calculate Mean Frequency
mean_freq = mean(mean(freqs));

%Plot
figure(1)
plot( (1:N), freqs,'X--');
axis([-1 N+2 .95*mean_freq 1.05*mean_freq ])

figure(2)
imagesc(norm_V(:,end/2:end))

