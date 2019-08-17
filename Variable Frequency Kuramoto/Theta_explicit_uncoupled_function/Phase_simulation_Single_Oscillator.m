clear
clc
close all
%Simulation Parameters:
omega = 2*pi;

%Initialization
t = (0:.001:20);
%% Uncoupled Phase Trace

%b = 0
xa = unwrap(phi_t(t,0,omega));

%b = .5
xb = unwrap(phi_t(t,.5,omega));

%b = .7
xc = unwrap(phi_t(t,.7,omega));

%b = .95
xd = unwrap(phi_t(t,.95,omega));

%b = .99
xe = unwrap(phi_t(t,.99,omega));

%{
position = sin(xe);
velocity = cos(xe).*omega.*(1+.99.*sin(xe)); 

plot(position,velocity)
%}

subplot(2,1,1)
plot(t,(xa),'linewidth',2.3,'color',[0 0 0]);
title('Phase Versus Time for a single uncoupled oscillator','FontSize',12);
hold on
plot(t,(xb),'--','linewidth',2.3,'color',[0 0 1]);
plot(t,(xc),':','linewidth',2.3,'color',[0 1 0])
plot(t,(xd),'-','linewidth',2.3,'color',[1 0 0])
plot(t,(xe),'-','linewidth',1,'color',[1 0 1])
legend('b = 0','b = .5','b = .7','b = .95', 'b = .99');
axis([0 20 0 25])

%{
for i = 0:3
    vline(pulse_time(.99,omega,i),'bl');
end
hold off
%}

subplot(2,1,2)
plot(t,sin(xe),'-','linewidth',2,'color',[0 0 0])
hold on
axis([0 20 -1.5 1.5]);
title('Sinusoidal Phase Versus Time for a single uncoupled oscillator,b = .99','FontSize',12);
xlabel('Time (s)','FontSize',12);
ylabel('Phase (rad)','FontSize',12);
set(gca,'FontSize',12);
legend('sine of phase','cosine of phase');
%{
for i = 0:3
    vline(pulse_time(.99,omega,i),'blue');
end
hold off
%}
