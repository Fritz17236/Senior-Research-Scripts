clear
clc
close all
%Simulation Parameters:
omega = 2*pi;
b   = .99;

phi_0 = 0;
%Initialization
t = (0:.001:20);



for i = 1:2
    
    
phase(i,:) = unwrap(phi_t(t,b,omega,0));

voltages(i,:) = sin(phase(i,:));

%vDot is d/dt (V(phi(t))) = dV/dphi * dphi/dt
vDots(i,:) = cos(phase(i,:)).*omega.*(1+b.*sin(i*phase(i,:)));

plot(voltages(i,:),vDots(i,:));
end
hold off
label1 = 'V_{dot} = cos(phi) * omega(1+bsin(phi))';
label2 = 'V_{dot} = cos(phi) * omega(1+bsin(2*phi))';
plot(voltages(1,:),vDots(1,:),voltages(2,:),vDots(2,:));
legend(label1,label2);
xlabel('Voltage = sin(phi)');
ylabel('V_{dot}');
title('Phase portrait of a single oscillator ');
