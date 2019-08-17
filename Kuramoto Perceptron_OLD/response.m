%Gaussian Tuning Curve%
%function will be gaussian tuning curve that represents the
%firing rate of a neuron as a function of the orientation  angle of a
%bar of light moving accross the visual cortex region of a monkey

%r is firing rate (Hz) , s is orientation angle (in degrees)
%r(s) = r_max * exp( -.5 * ( ( s-s_max) / sigma_f )^2 ) 
%Curve adopted from Theoretical Neuroscience,Dayan et Al. pg. 15


function firing_rate = response(stimulus) 
f_max = 52.12;    %max firing rate (Hz)
s_max = 0;        %stimulus at r_max (degrees)
sigma_f = 14.73;  %frequency deviation term (degrees)

firing_rate = f_max*exp(-.5 * ((stimulus - s_max)/sigma_f).^2 );
