function ButterflyValue = butterflyVal(SpotPrice, StrikePrice, RiskFreeRate, TimeExpiry, Volatility, ButterflyRange, varargin)
% Compute the value of the butterfly contract
% SYNTAX: 
% ButterflyValue = butterflyVal(SpotPrice, StrikePrice, RiskFreeRate, TimeExpiry, Volatility, ButterflyRange)

% Copyright 2013 MathWorks, Inc.

% Check for right length of input
if nargin < 6
    errordlg('Function Requires 7 inputs','Input Length Error','on')
end

TimeExpiry = TimeExpiry / 12;
ButterflyValue = blsbtyval(SpotPrice, StrikePrice, RiskFreeRate, ...
    TimeExpiry, Volatility, ButterflyRange);