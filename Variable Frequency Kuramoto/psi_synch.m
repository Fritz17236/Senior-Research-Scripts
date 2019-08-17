%psi synch function evaluates the mean phase, Psi, at the pulse time
%predicted by the pulse_time function (see paper for more details). It
%returns a mean value of psi evaluated at each pulse time.

function mean_psi = psi_synch(psis,w,b,pulse_count,dt,t)
psi_vec = zeros(1,pulse_count);
plot(t,psis)
for i = 1:pulse_count
    time_of_pulse = pulse_time(b,w,i-1); %pulse time in seconds
    pulse_index   = floor(time_of_pulse/dt);  %pulse time in timesteps
    psi_vec(1,i) =  psis(pulse_index);
    vline(time_of_pulse);
end
mean_psi = mean(psi_vec);