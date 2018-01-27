%% Quantile Regression with R
% In this example, we demonstrate how to invoke and exchange data with
% R packages. We will use the R package 'quantreg' to perform quantile
% regression analysis and determine the variation in beta estimates on a
% percentile basis for certain stocks in the S&P 500 index.
%
% This example will also demonstrate how to port plots created in R from
% within MATLAB.

% Copyright 2013 MathWorks, Inc.

clc; clear

%% 0. Preferences
% Define the location of the R binaries 
Rlocation = 'C:\Program Files\R\R-3.0.1\bin';

%% 1. Import data
% Import data from Yahoo! Finance data feed. If not available, data will be
% loaded from a MAT-file. Historical data for AAPL and SPY will be imported
% for a 4 year period
symbols = {'AAPL', 'SPY'};
FirstDay = '1/1/2009';
LastDay = '12/31/2012';

try
    conn = yahoo;
    
    Data = fetch(conn, symbols{1}, {'Adj Close'}, FirstDay, LastDay);
    Data = flipud(Data); % Rearrange to oldest first
    StkPrices = Data(:,2);
    Data = fetch(conn, symbols{2}, {'Adj Close'}, FirstDay, LastDay);
    Data = flipud(Data); % Rearrange to oldest first
    IdxPrices = Data(:,2);
    
    close(conn);
    clear conn i Data symbols;
catch
    load QRData
end

%% 2. Set up link to R
% We use the 'RCaller' Java package to connect to the R environment.
% Setting the path to the executables enables us to pass code and data
% back and forth.
javaaddpath 'RCaller-2.1.1-SNAPSHOT.jar'
import rcaller.RCaller.*;
caller = rcaller.RCaller;

caller.setRscriptExecutable([strrep(Rlocation, '\', '\\') '\\Rscript.exe']);
caller.setRExecutable([strrep(Rlocation, '\', '\\') '\\R.exe']);

%% 3. Generate R code to pass data into R and plot analysis 
% Code is added to send AAPL closing price data. The "Test.R" script
% assumes this data has been stored in a variable named 'Stock'. The script
% performs a quantile regression-based beta estimation of AAPL vs SPY.
% Ref: "Refining Our Understanding Of Beta through Quantile Regression", AB
% Atkins, Apr 2010; 
% http://franke.nau.edu/images/uploads/fcb/BetaQuantileRegression.pdf
caller.cleanRCode;
%rCode = caller.getRCode;
rCode = rcaller.RCode();

% Send Data
rCode.addDoubleArray('Stock', StkPrices);
rCode.addDoubleArray('Index', IdxPrices);
tau = (1:49)/50; % Quantiles
rCode.addDoubleArray('Tau', tau);

% Add code or a source file
rCode.addRCode(['source("' strrep(pwd, '\', '/') '/qreg.R")']);

% Add plotting code
imgLink = rCode.startPlot();
rCode.addRCode('plot(summary(fit))');
rCode.endPlot();

%% 4. Execute code and display result
% Once the code is executed by the R engine, MATLAB can read and display
% the plot.
try
    caller.setRCode(rCode);
    %caller.runOnly; % If no outputs are desired
    caller.runAndReturnResult('coef');
    parser = caller.getParser();
    coef = parser.getAsDoubleArray('coef');
catch ExecError
    disp 'Error caught.';
end

%% Display results in MATLAB
try
    dataset({[tau' reshape(coef,2,[])'], 'Tau', 'Intercept', 'Index'})
catch
    disp('Tau, Intercept, Index:')
    disp([tau' reshape(coef,2,[])'])
end

%% Retrieve image
% Display or read in plot generated in R

readIntoMATLAB = false;
if readIntoMATLAB || ~ispc
    [I,map] = imread(char(imgLink.getAbsolutePath),'png');
    figure;image(I); colormap(map);    
else
    % Open the image file in Windows
    winopen(char(imgLink.getAbsolutePath))
end
