clear
clc
close all
%Simulation Parameters:
omega = 2*pi;
%% Uncoupled Phase Trace

%b = 0
b = 0*omega;     %Frequency function gain parameter
f = @(t,theta) [ omega + b*sin(theta) ];
[t,xa] = ode45(f,[0:.001:20],[0]);

%b = .5
b = .5*omega;     %Frequency function gain parameter
f = @(t,theta) [ omega + b*sin(theta) ];
[t,xb] = ode45(f,[0:.001:20],[0]);

%b = .7
b = .7*omega;     %Frequency function gain parameter
f = @(t,theta) [ omega + b*sin(theta) ];
[t,xc] = ode45(f,[0:.001:20],[0]);

%b = .95
b = .95*omega;     %Frequency function gain parameter
f = @(t,theta) [ omega + b*sin(theta) ];
[t,xd] = ode45(f,[0:.001:20],[0]);

%b = .99
b = .99*omega;     %Frequency function gain parameter
f = @(t,theta) [ omega + b*sin(theta) ];
[t,xe] = ode45(f,[0:.001:20],[0]);

%xa = wrapTo2Pi(xa);
%plot(t,(xa),'linewidth',2.3,'color',[0 0 0]);
%hold on
%plot(t,(xb),'--','linewidth',2.3,'color',[0 0 0]);
%plot(t,(xc),':','linewidth',2.3,'color',[0 0 0])
plot(t,sin(xd),'-','linewidth',2.3,'color',[0 0 0])
%hold on
%plot(t,(xe),'-','linewidth',1,'color',[0 0 0])

title('Sine ofPhase Versus Time for a single uncoupled oscillator','FontSize',12);
xlabel('Time (s)','FontSize',12);
ylabel('Phase (rad)','FontSize',12);
axis([0 4*pi -2 2]);
set(gca,'FontSize',12);
legend('b = .95','b = .5','b = .7','b = .95','b = .99');



