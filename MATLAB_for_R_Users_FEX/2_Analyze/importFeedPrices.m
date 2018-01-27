function [dates, prices, ds] = importFeedPrices(tickers, startPeriod, endPeriod)
% Import prices for a set of tickers from a datafeed

% Copyright 2013 MathWorks, Inc.

%% Connect to Yahoo datafeed
try
    conn = yahoo;
catch ME
    load tsData;
    return
end

%% Loop through tickers and import data
n = length(tickers);
ts = cell(1,n);
for i = 1:n
    data = fetch(conn, tickers{i}, startPeriod, endPeriod);
    ts{i} = fints(data(:,1), data(:,7), tickers{i});
end

%% Merge and align time series
allTs = merge(ts{:});

dates = allTs.dates;
prices = fts2mat(allTs, tickers);
ds = dataset({cellstr(datestr(dates)),'Date'}, [{prices}, tickers]);

%% Save for later
save tsData dates prices ds