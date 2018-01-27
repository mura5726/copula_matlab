function [SpotMat, TimeMat] = calcrange(SpotPrice, TimeExpiry, VizRange)
%CALCRANGE Compute spot price and time to expiry range based on visualization
%range

% Copyright 2013 MathWorks, Inc.

%Compute a step for the spot price range which scales based on the magnitude
%of the spot price and the visualization range
SpotStep = (SpotPrice - SpotPrice * (1 - VizRange / 2)) / 10;

%Compute the range of spot prices based on the visualization range
SpotRange = SpotPrice * (1 - VizRange / 2) : ...
     SpotStep : SpotPrice * ((1 + VizRange / 2));

%Compute a step for the time to expiry range which scales based on the
%magnitude of the time to expiry and the visualization range
TimeStep = (TimeExpiry / 12) / 30;

%Compute the range of times to expiry
TimeRange = 0 : TimeStep : TimeExpiry / 12;

%Generate matrix spot prices and times to expiry based on the size of the
%spot price and time to expiry ranges
[SpotMat, TimeMat] = meshgrid(SpotRange, TimeRange);

%end of CALCRANGE subroutine
