function ButterflyValue = blsbtyval(SpotPrice, StrikePrice, RiskFreeRate, ...
          TimeExpiry, Volatility, ButterflyRange)
%BLSBTYVAL Black Scholes value of a butterfly option

% Copyright 2013 MathWorks, Inc.

%Set the different strike prices
LowStrike = StrikePrice .* (1 - ButterflyRange);
HighStrike = StrikePrice .* (1 + ButterflyRange);

%Value the long positions in the low and high struck calls
LowValue = blsprice(SpotPrice, LowStrike, RiskFreeRate, ...
     TimeExpiry, Volatility);
HighValue = blsprice(SpotPrice, HighStrike, RiskFreeRate, ...
     TimeExpiry, Volatility);

%Value the short position in the calls struck at the initial strike
%price
ShortValue = 2 .* -(blsprice(SpotPrice, StrikePrice, RiskFreeRate, ...
     TimeExpiry, Volatility));

%Calculate the total value of the butterfly
ButterflyValue = LowValue + HighValue + ShortValue;