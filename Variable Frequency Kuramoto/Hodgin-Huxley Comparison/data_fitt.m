%Script for analyzing Wien-Bridge Oscillator Data

clear;
clc
close all

%data is a 20(N) x 5000(T) vector containing Wien-Bridge Oscillator Data
%Data is raw voltage trace of each oscillator 
%First import the data   
load('50_neurons.mat');
data = V_t;
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
% fit to neuron data DONT DELETE

plot(ts,phases)

freq = 2.59;
phi_0 = phases(1,1) + 2;
%Calculate similar Phase Trace using Model
b = .9;

omega_desired = freq*2*pi;  % 300 Hz
omega = omega_desired./sqrt(1-b^2); %demodulate transformed space
calc_phases = unwrap(phi_t(ts,b,omega,phi_0));
calc_phases = calc_phases +1.3*pi;

sines = sin(calc_phases(1,1:end-1));

plot(sines,diff(sin(calc_phases)));
hold on
plot(voltages(1,1:end-1),diff(voltages(1,:)))

%}