function visualizeFrontier(p, portRisk, portReturn)
% Plot efficient frontier along with asset moments
%
% USAGE: 
% With a PortfolioCVaR object:
%    plotRiskReturnsFrontier(p, portRisk, portReturn, scale)
%
% p is a Portfolio object that contains asset moments

% Copyright 2013 MathWorks, Inc.

nAssets = length(p.AssetList);
% Extract asset moments & names
assetReturn = p.estimatePortReturn(eye(nAssets));
assetRisk = p.estimatePortRisk(eye(nAssets));
assetNames = p.AssetList;

 
scatter(assetRisk, assetReturn, 6, 'm', 'Filled');
hold on
for k = 1:length(assetNames)
    text(assetRisk(k), assetReturn(k), [' ' assetNames{k}], 'FontSize', 8);
end
plot(portRisk, portReturn, 'bo-', 'MarkerFaceColor', 'b');
hold off;

xlabel('Expected Risk (CVaR)');
ylabel('Expected Return');
grid on;
%set(gcf,'Renderer','opengl');
% subplot(2,1,2);
% plot(portRisk, portReturn./portRisk, 'bo-', 'MarkerFaceColor', 'b');
% xlabel('Risk (Std Dev of Active Return)');
% ylabel('Information Ratio');
% grid on;
