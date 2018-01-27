function m = ema(x,N)
% Calculate simple moving average
% m = ema(x, N)
% x is the time series and N is the number of observations in the time
% period

% Copyright 2013 MathWorks, Inc.

L = length(x);
m = zeros(L,1);
w = 2/(N+1);
m(1) = x(1);
for i = 2:L
    m(i) = w*x(i) + (1-w)*m(i-1);
end