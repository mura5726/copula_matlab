function posPNLPlot(x, pos, pnl)

% Copyright 2013 MathWorks, Inc.

changePos = [false; logical(diff(pos))];

ax1 = subplot(2,1,1);
plot(x);
hold on;
ind = find(pos == 1 & changePos);
plot(ind, x(ind), 'g^', 'Markersize', 6, 'MarkerFaceColor', 'g');
ind = find(pos == -1 & changePos);
plot(ind, x(ind), 'rv', 'Markersize', 6, 'MarkerFaceColor', 'r');
ind = find(pos == 0 & changePos);
plot(ind, x(ind), 'k*', 'Markersize', 4);
hold off;
legend('Series','Long', 'Short', 'Close');
grid on;
ylabel('Price');
title('Time series and positions');
ax2 = subplot(2,1,2);
plot(cumsum(pnl));
title('Cumulative PNL');
ylabel('Profit');
grid on;
linkaxes([ax1 ax2],'x');