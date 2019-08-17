% xcorr demo
%
% The signals
t = [0:127]*0.02;
f = 1.0;
s1 = sin(2*pi*f*t);
s2 = sin(2*pi*f*(t-0.35)); % s1 lags s2 by 0.35s
subplot(2,1,1);
plot(t,s1,'r',t,s2,'b');
grid
title('signals')
%
% Now cross-correlate the two signals
%
x = xcorr(s1,s2,'coeff');
tx = [-127:127]*0.02;
subplot(2,1,2)
plot(tx,x)
grid
%
% Determine the lag
%
[mx,ix] = max(x);
lag = tx(ix);
hold on
tm = [lag,lag];
mm = [-1,1];
plot(tm,mm,'k')
hold off
% Note that the lag is only as close as the time resolution.
% i.e. actual = -0.35, calculated = -0.34
S = sprintf('Lag = %5.2f',lag);
title(S)