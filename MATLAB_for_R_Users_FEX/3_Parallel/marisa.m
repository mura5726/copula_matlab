function [sh, pnl, pos] = marisa(x, N, M, cost)
%#codegen
% MARISA computes the sharpe ratio, P&L & positions from running the MA+RSI
% combo strategy on a time series for a given choice of EMA and RSI
% parameters and a trade cost
% Syntax: [sh, pnl, pos] = marisa(x, N, M, cost)

% Copyright 2013 MathWorks, Inc.

% Fixed strategy parameters
downThresh = 55;
upThresh = 45;

S = length(x);
e = ema(x,N);
% take the RSI of the detrended series
r = rsi2(x-ema(x,15*M),M);

% Compute EMA Positions
epos = sign(x-e);

% Compute RSI Positions
rpos = zeros(S-1,1);
% Crossing threshold down
I = r(2:end) <= downThresh & r(1:end-1) > downThresh; 
rpos(I) = -1;
% Crossing threshold up
I = r(2:end) >= upThresh & r(1:end-1) < upThresh;
rpos(I) = 1; 
% copy down previous position values
rpos = [0; rpos]; % Start from 0 state
for i = 2:S
    if rpos(i) == 0
        rpos(i) = rpos(i-1);
    end
end

% Calculate combined signal position
pos = zeros(S,1);
pos(rpos ==  1 & epos ==  1) =  1;
pos(rpos == -1 & epos == -1) = -1;

% pnl calculation
pnl = pos(1:end-1).*diff(x) - abs(diff(pos))*cost/2;
sh = sqrt(250) * mean(pnl)/std(pnl);
