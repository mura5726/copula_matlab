%% Sample interactive plotting in MATLAB

% Copyright 2013 MathWorks, Inc.

%% Import Data
importScript

%% Pre-process
% Convert dates
dates = datenum(priceData.Date, 'yyyy-mm-dd') + priceData.Hour/24;
daPrice = max(reshape(priceData.DA_EC,24,[]))';
rtPrice = max(reshape(priceData.RT_LMP,24,[]))';
conComp = max(reshape(priceData.DA_CC,24,[]))';
dates = dates(1:24:end);

%% Create Plot
figure(1); clf
ax1 = subplot(2,1,1);
plot(dates, [daPrice rtPrice], 'LineWidth', 1); grid on;
axis tight
ylabel('Price ($/MWh)');
legend({'Day Ahead', 'Real Time'});
legend('boxoff');
ax2 = subplot(2,1,2);
plot(dates, conComp, 'LineWidth', 1); grid on;
ylabel('Price ($/MWh)');
legend('Congestion component'); legend boxoff
axis tight
linkaxes([ax1 ax2], 'x');
dynamicDateTicks([ax1 ax2], 'link');

figure(2); clf
plot(daPrice, rtPrice, '.', 'markersize', 3);
axis tight;
xlabel('Day Ahead'); ylabel('Real Time'); grid on;
linkdata on

figure(1);
linkdata on;