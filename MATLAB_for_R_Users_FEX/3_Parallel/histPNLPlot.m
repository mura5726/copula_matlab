function histPNLPlot(cpnl, posPNL, period)

% Copyright 2013 MathWorks, Inc.

figure
subplot(2,1,1); 
plot(1:length(cpnl),cpnl,'b',period(1):period(2),cpnl(period(1):period(2)),'r');
line(period([1 1]),ylim,'linestyle',':');
line(period([2 2]),ylim,'linestyle',':');
grid on;
title('Cumulative PNL with Max Drawdown Period');
subplot(2,1,2);
hist(posPNL,100);
pct = prctile(posPNL,[5 10 25 50]);
line(pct(1)*[1 1],ylim,'Color','r');
line(pct(2)*[1 1],ylim,'Color','r');
line(pct(3)*[1 1],ylim,'Color','r');
line(pct(4)*[1 1],ylim,'Color','r');
title('Distribution of position profits & risk');
legend('Profits','5th Pctl','10th Pctl','25th Pctl','50th Pctl');
grid on

xlabel('$');