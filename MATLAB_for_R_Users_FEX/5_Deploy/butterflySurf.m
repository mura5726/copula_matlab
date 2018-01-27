function butterflySurf(SpotPrice, StrikePrice, RiskFreeRate, TimeExpiry, Volatility, ButterflyRange, VizRange)
% Surface plot of the option price as a function of strike price and time
% to expiration.
% SYNTAX:
% butterflySurf(SpotPrice, StrikePrice, RiskFreeRate, TimeExpiry, Volatility, ButterflyRange, VizRange)

% Copyright 2013 MathWorks, Inc.

% Check for right length of input
if nargin < 7
    errordlg('Function Requires 7 inputs','Input Length Error','on')
end

%Compute ranges for the spot price and time to expiry based on the
%specified visualization range
[SpotMat, TimeMat] = calcrange(SpotPrice, TimeExpiry, VizRange);

%Price the option over the ranges
ButterflyValue = blsbtyval(SpotMat, StrikePrice, RiskFreeRate, ...
    TimeMat, Volatility, ButterflyRange);

%Plot the resulting value surface
hqr = surf(SpotMat, TimeMat, ButterflyValue, gradient(ButterflyValue, diff(SpotMat(1,1:2)), diff(TimeMat(1:2))));
xlabel('Spot Price');
ylabel('Time to Expiry');
zlabel('Option Value');
title('Butterfly Option');
surfOptions(hqr);
     