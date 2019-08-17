%Script for analyzing Wien-Bridge Oscillator Data



%data is a 20(N) x 5000(T) vector containing Wien-Bridge Oscillator Data
%Data is raw voltage trace of each oscillator 
%First import the data   

clear
 clc 
load('data.mat');
N = numel(data(:,1));
dt = 1e-3;
%Create ts vector
ts = (1*dt:dt:dt*numel(data(1,:)));
T = numel(ts);

%Normalize Data to +/- 1
data = data./max(max(data));

%raw voltage here is sin(phi), therefore mean phase is
for i = 1:N
    complex_phase(i,:) = hilbert(data(i,:));
    a = complex_phase(i,:);
    phases(i,:) = unwrap( atan2(imag(a),real(a) ) );
    Amplitudes(i,:) = sqrt( imag(a).^2 + real(a).^2);
    voltages(i,:) = data(i,:);
    rad_freq(i) = (phases(i,end) - phases(i,1)) / (dt*T);
end





%{
%fit to Wien_bridge DONT DELETE
phi_0 = phases(1,1);
%Calculate similar Phase Trace using Model
b = .6;

omega_desired = rad_freq(1);  % 300 Hz
omega = omega_desired./sqrt(1-b^2); %demodulate transformed space
calc_phases = unwrap(phi_t(ts,b,omega,phi_0));
calc_phases = calc_phases;


plot(ts,phases(1,:),ts,calc_phases);
legend('Wien-Bridge Extracted Phase','Model Predicted Phase')
%}

%{
% fit to neuron data DONT DELETE

plot(ts,phases)

freq = rad_freq;
phi_0 = phases(1,1) + 2;
%Calculate similar Phase Trace using Model
b = .9;

omega_desired = rad_freq;  % 300 Hz
omega = omega_desired./sqrt(1-b^2); %demodulate transformed space
calc_phases = unwrap(phi_t(ts,b,omega,phi_0));
calc_phases = calc_phases +1.3*pi;

plot(ts,phases,ts,calc_phases)
xlabel('Time (mS)');
ylabel('Phase (rad)');
legend('Phase Extracted from Neuron','Phase Predicted by Model');

%}


figure
line(ts,data(10:18,:),'Color','r')
ax1 = gca; % current axes
ax1.XColor = 'r';
ax1.YColor = 'r';

ax1_pos = ax1.Position; % position of first axes
ax2 = axes('Position',ax1_pos,...
    'XAxisLocation','top',...
    'YAxisLocation','right',...
    'Color','none');

line(ts,coherence(phases),'Parent',ax2,'Color','k')
