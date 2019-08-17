%RK2 Kurmaoto Simulation
close all
clear
clc
%simulation parameters
dt    = 1e-4;               %Timestep
N     = 10;                 %Number of oscillators
omega = 50*2*pi;           %average natural frequency
sigma = .05*omega;          %standard deviation of frequencies
b     = .99;                %Frequency Strength Paramter
omega = omega/sqrt(1-b^2);  %Undo pulse modulation 
T     = .5;                 %Maximum Time
alpha = 30;                  %Coactive Learning Parameter

%initialization
t           = zeros(1,round(T/dt));       %create t vector for storing time vector
omega_o     = normrnd(omega,sigma,N,1);   %natural frequency for each oscillator
init_thetas =  3*pi/2;                    %initial phases for each oscillator
count       = 1;                          %iteration count for storing data in vectors
t_index     = 0;                          %time index that governs while loop
xa          = zeros(N,round(T/dt));       %Initialize data vector for Phases vs Time
xa(:,1)     = init_thetas;                %set initial phases
Ks          =  zeros(N,N,round(T/dt));    %coupling  matrix
    
%Run through simulation
 while t_index < T -dt  
   %calculate derivatives
    d_thetas = theta_dot(xa(:,count),omega_o,Ks(:,:,count),b); 
    
if count > 1000;  %cannot modify synaptic weights until enough data is present (count > Tau_max / dTau --see dK function for details)
        d_Ks     = dK(xa,alpha,count,dt);   
        Ks(:,:,count+1) = Ks(:,:,count) + dt*d_Ks;
        %impose saturation constraints: Kmax = 1, Kmin = -1
         A = Ks > 1;
         B = Ks < -1;
         Ks(A)  = 1;
         Ks(B)  = -1;

    end
    %calculate and store next values, record time
    xa(:,count+1)   = xa(:,count) + dt*d_thetas;   
    t(count+1)      = t_index+dt;
    
    %update time and count indices
    t_index = t_index + dt;       
    count   = count + 1;  
 end
 
 

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

