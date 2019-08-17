%RK2 Kurmaoto Simulation
close all
clear
clc
%simulation parameters
dt = 1e-3;               %Timestep
N = 2;                   %Number of oscillators
omega = 60*2*pi;         %average natural frequency
b = .99;                 %Frequency Strength Paramter
omega = omega/sqrt(1-b^2);
sigma = .05*omega;       %standard deviation of frequencies
T =  1;                 %Maximum Time
K  = 0;

%initialization
omega_o     = normrnd(omega,sigma,N,1);   %frequency for each oscillator
init_thetas =  normrnd(0,10*pi,N,1);     %initial phases
    
    
f = @theta_dot;

    [t,thetas] = ode113(@(t,x) f(x,omega_o,K,b,t),[0:dt: T],init_thetas);

thetas = thetas';


%{
%plot with options ...

figure
subplot(3,1,1)
plot(t,coherence((xa)),'LineWidth',2);
    hold on

title('Coherence, r, Versus Time for 100 Coupled Oscillators','FontSize',12);
xlabel('Time (s)','FontSize',12);
ylabel('Coherence','FontSize',12);
axis([0 T 0 1]);
set(gca,'FontSize',12);

for i = 0:6
    vline(pulse_time(b,omega,i),'b');
end


subplot(3,1,2)
plot(t,psis(xa),'LineWidth',2,'MarkerSize',2)
title('Mean Phase, Psi, Versus Time for 100 Coupled Oscillators','FontSize',12);
xlabel('Time (s)','FontSize',12);
ylabel('Mean Phase, Psi','FontSize',12);
axis([0 T -1 1.5]);
set(gca,'FontSize',12);

hold on

for i = 0:6
    vline(pulse_time(b,omega,i),'b');
end


subplot(3,1,3)
plot(t,sin(xa(1:end/2,:)))
title('Sine of Phase Versus Time for 100 Coupled Oscillators','FontSize',12);
xlabel('Time (s)','FontSize',12);
ylabel('Sine of Phase','FontSize',12);
axis([0 T -1 1.5]);
set(gca,'FontSize',12);


for i = 0:6
    vline(pulse_time(b,omega,i),'b');
end
hold off
%}
%{
rez=1200; %resolution (dpi) of final graphic
f=gcf; %f is the handle of the figure you want to export
figpos=getpixelposition(f); %dont need to change anything here
resolution=get(0,'ScreenPixelsPerInch'); %dont need to change anything here
set(f,'paperunits','inches','papersize',figpos(3:4)/resolution,'paperposition',[0 0 figpos(3:4)/resolution]); %dont need to change anything here
path='C:\Users\Fritz\Google Drive\School\Senior Research\Scripts\Variable Frequency Kuramoto'; %the folder where you want to put the file
name='simulation.png'; %what you want the file to be called
print(f,fullfile(path,name),'-dpng',['-r',num2str(rez)],'-opengl') %save file 

%} 

