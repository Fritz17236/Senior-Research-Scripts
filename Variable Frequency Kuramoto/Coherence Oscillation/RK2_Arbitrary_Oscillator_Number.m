%RK2 Kurmaoto Simulation
close all
clear
clc
%simulation parameters
N = 1;                  %Number of oscillators
omega = 2*pi;             %average natural frequency
sigma = .0;               %standard deviation of frequencies
K = 1;                    %Global Coupling Strength
b = .99;
b_tilde = b*(omega-3*sigma);  %Frequency Strength Paramter

%b = 5, w_o = 16
%initialization
omega_o = normrnd(omega,sigma,N,1);    %frequency for each oscillator
init_thetas = normrnd(0,pi,N,1);  %initial phases
%wrapTo2Pi(init_thetas);
%omega_o  = ones(N ,1);
%init_thetas = ones(N,1);
%init_thetas(1:N/2,1) = pi;
%init_thetas(1,1) = 1.001;
f = @theta_dot;

    [t,xa] = ode15s(@(t,thetas) f(thetas,omega_o,K,b_tilde,t),[0:.001:20],init_thetas);

xa = xa';
%figure 
%plot(t(:),sin(xa))
%figure
%plot(theta_dot(xa(100:1000,1),omega_o(1),K,b,t)*.01)
figure
subplot(2,1,1)
plot(t,coherence((xa)),'LineWidth',3);
title('Coherence, r, Versus Time for 250 Coupled Oscillators','FontSize',12);
xlabel('Time (s)','FontSize',12);
ylabel('Coherence','FontSize',12);
axis([0 20 0 1]);
set(gca,'FontSize',12);
subplot(2,1,2)
plot(t,sin(xa))
title('Sin of Phase Versus Time for 250 Coupled Oscillators','FontSize',12);
xlabel('Time (s)','FontSize',12);
ylabel('Sin(Phase)','FontSize',12);
axis([0 20 -1 1.5]);
set(gca,'FontSize',12);
hold on
y = (-2:.01:2);

natural_mod_freq = (omega*sqrt(1-b.^2));
nat_mod_period = (2*pi)/natural_mod_freq;

for i = 1:10
    plot(i*nat_mod_period,y)
end
%legend('b = .99','b = .3','b = .7','b = .9','b = .99');




