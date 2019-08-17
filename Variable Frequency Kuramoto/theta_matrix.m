%RK2 Kurmaoto Simulation
close all
clear
clc
%simulation parameters
dt = 1e-3;               %Timestep
N = 20;                  %Number of oscillators squared
omega = (2*pi)/.25;      %average natural frequency

sigma = .01*omega;       %standard deviation of frequencies
b = .99;                 %Frequency Strength Paramter
omega = omega/(sqrt(1-b^2));

T = 10;                 %Maximum Time
K  = 1;

    t = zeros(1,floor(T/dt));
    omega_o = normrnd(omega,sigma,N,N,1);   %frequency for each oscillator
    init_thetas =  3*pi/2;     %initial phases
    count = 1; 
    t_index = 0;
    xa = zeros(N,N,floor(T/dt));      %Initialize data vector for Phases vs Time
    xa(:,:,1) = init_thetas;   %set initial phases
    
    while t_index < T
    
        d_thetas = theta_dot_matrix(xa(:,:,count),omega_o,K,b,t_index);   %calculate derivative
        xa(:,:,count+1) = xa(:,:,count) + dt*d_thetas;         %calculate and record next value
        t(count+1) = t_index+dt;
        t_index = t_index + dt;         %update time
        count = count + 1;  %update count\index #
    end
     

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

