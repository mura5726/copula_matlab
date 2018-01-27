function blsmaincall2(Request)
%BLSMAINCALL2 Main callback switchyard for BLSAPP application

%Author: C. Bassignani, 01-11-99

% Copyright 2013 MathWorks, Inc.


%-----------------------------------------------------------------------------
%Run specific subroutines based on the callback request
switch(Request)
   
case 'radiocall'
     clear
     close(findobj('Tag', 'OutputFigure')) 
     %Make the radio buttons mutually exclusive
     radioexclusive;
     
     %Make sure the butterfly edit field and label are off
     butterflyoff;
     
     %Set the a flag in the application data structure to indicate the option
     %type
     DataStruct = get(gcf, 'UserData');
     DataStruct.OptionType = 1;
     set(gcf, 'UserData', DataStruct);
     
case 'radioput'
     clear
     close(findobj('Tag', 'OutputFigure'))
     %Make the radio buttons mutually exclusive
     radioexclusive;
     
     %Make sure the butterfly edit field and label are off
     butterflyoff;
     
     %Set the a flag in the application data structure to indicate the option
     %type
     DataStruct = get(gcf, 'UserData');
     DataStruct.OptionType = 2;
     set(gcf, 'UserData', DataStruct);
     
case 'radiostraddle'
     clear
     close(findobj('Tag', 'OutputFigure'))
     %Make the radio buttons mutually exclusive
     radioexclusive;
     
     %Make sure the butterfly edit field and label are off
     butterflyoff;
     
     %Set the a flag in the application data structure to indicate the option
     %type
     DataStruct = get(gcf, 'UserData');
     DataStruct.OptionType = 3;
     set(gcf, 'UserData', DataStruct);
     
case 'radiobutterfly'
     clear
     close(findobj('Tag', 'OutputFigure'))
     %Make the radio buttons mutually exclusive
     radioexclusive;
     
     %Turn on the butterfly range edit box and label
     butterflyon;
     
     %Set the a flag in the application data structure to indicate the option
     %type
     DataStruct = get(gcf, 'UserData');
     DataStruct.OptionType = 4;
     set(gcf, 'UserData', DataStruct);
     
case 'calculate'
     
     %Call the calculation subroutine
     calcroutine;
     
case 'visualize'
     
     %Call the visualization subroutine
     vizroutine;
     
case 'closeall' % Close all GUI's
     
     close(findobj('Tag', 'OutputFigure'));
     delete(gcbf);
     
otherwise
     
     return
     
end

%end of BLSMAINCALL2 function

%-------------------------------------------------------------------------------
%
%                                SUBROUTINES
%
%-------------------------------------------------------------------------------
function butterflyoff()
%BUTTERFLYOFF Turn the butterfly edit field and label off

%Get the handle of the label and turn it off
TextHandle = findobj(gcbf, 'Tag', 'TextButterflyRange');
set(TextHandle, 'Enable', 'off');

%Get the handle of the edit box and turn it off
EditHandle = findobj(gcbf, 'Tag', 'EditButterflyRange');
set(EditHandle, 'Enable', 'off');

%Set the background color of the edit box to the default color
set(EditHandle, 'BackgroundColor', 'default');

%end of BUTTERFLYON subroutine

%-----------------------------------------------------------------------------
function butterflyon()
%BUTTERFLYON Turn the butterfly edit field and label on

%Get the handle of the label and turn it on
TextHandle = findobj(gcbf, 'Tag', 'TextButterflyRange');
set(TextHandle, 'Enable', 'on');

%Get the handle of the edit box and turn it on
EditHandle = findobj(gcbf, 'Tag', 'EditButterflyRange');
set(EditHandle, 'Enable', 'on');

%Set the background color of the edit box to the white
set(EditHandle, 'BackgroundColor', 'white');

%end of BUTTERFLYON subroutine

%-----------------------------------------------------------------------------
function radioexclusive()
%RADIOEXCLUSIVE Make the radio buttons mutually exclusive

if isempty(gcbo)
  return
end

%Get the handles of all radio buttons (they all have the same tag)
RadioHandle = findobj('Tag', 'RadioButton');

%Set all radio buttons to off
set(RadioHandle, 'Value', 0);

%Set the current call back object to on
set(gcbo, 'Value', 1);

%end of RADIOEXCLUSIVE subroutine

%-----------------------------------------------------------------------------
function calcroutine()
%CALCROUTINE Calculate the value of the option
close(findobj('Tag', 'OutputFigure'))
%Get all the input data from the GUI
[ErrorFlag, OptionType, SpotPrice, StrikePrice, RiskFreeRate, ...
          TimeExpiry, Volatility, VizRange] = getguidata; %#ok<NASGU>

if (~ErrorFlag && OptionType == 1) %Call option
     
     %Convert months to expiry to years to expiry
     TimeExpiry = TimeExpiry / 12;
     
     %Calculate the value of the option
     CallValue = blsprice(SpotPrice, StrikePrice, RiskFreeRate, ...
          TimeExpiry, Volatility);
     
     %Write the output back tot the GUI
     OutputHandle = findobj('Tag', 'EditAnswer');
     set(OutputHandle, 'String', num2str(CallValue));
     
elseif (~ErrorFlag && OptionType == 2) %Put option
     
     %Convert months to expiry to years to expiry
     TimeExpiry = TimeExpiry / 12;
     
     %Calculate the value of the put option
     [Temp, PutValue] = blsprice(SpotPrice, StrikePrice, RiskFreeRate, ...
          TimeExpiry, Volatility);
     
     %Write the output back tot the GUI
     OutputHandle = findobj('Tag', 'EditAnswer');
     set(OutputHandle, 'String', num2str(PutValue));
     
elseif (~ErrorFlag && OptionType == 3) %Straddle option
     
     %Convert months to expiry to years to expiry
     TimeExpiry = TimeExpiry / 12;
     
     %Compute the value of the straddle
     StraddleValue = blsstrval(SpotPrice, StrikePrice, RiskFreeRate, ...
          TimeExpiry, Volatility);
     
     %Write the output back tot the GUI
     OutputHandle = findobj('Tag', 'EditAnswer');
     set(OutputHandle, 'String', num2str(StraddleValue));
     
elseif (~ErrorFlag && OptionType == 4) %Butterfly option
     
     %Convert months to expiry to years to expiry
     TimeExpiry = TimeExpiry / 12;
     
     %Get the butterfly range
     Handle = findobj(gcbf, 'Tag', 'EditButterflyRange');
     ButterflyRange = str2double(get(Handle, 'String'));
     
     %Compute the value of the butterfly
     ButterflyValue = blsbtyval(SpotPrice, StrikePrice, RiskFreeRate, ...
          TimeExpiry, Volatility, ButterflyRange);
     
     %Write the output back tot the GUI
     OutputHandle = findobj('Tag', 'EditAnswer');
     set(OutputHandle, 'String', num2str(ButterflyValue));
     
end

%end of CALCROUTINE subroutine

%-----------------------------------------------------------------------------
function vizroutine()
%VIZROUTINE Visualize the value of the option over a range of inputs

%Get all the input data from the GUI
[ErrorFlag, OptionType, SpotPrice, StrikePrice, RiskFreeRate, ...
          TimeExpiry, Volatility, VizRange] = getguidata;

%Create the figure window within which the value surface of the option will
%be plotted
if (~ErrorFlag)
     OutHandle = findobj('Tag', 'OutputFigure');
     
     if (isempty(OutHandle))
          
          OutHandle = figure('Numbertitle', 'off', ...
               'Name', 'Option Pricing Visualization', ...
               'Tag', 'OutputFigure');
          
          %Normalize the units of all the controls
          AllUICtrlHandles = findobj(gcf, 'Type', 'uicontrol');
          set(AllUICtrlHandles, 'Units', 'normal');
     end
end

if (~ErrorFlag && OptionType == 1) %Call option
     
     %Compute ranges for the spot price and time to expiry based on the
     %specified visualization range
     [SpotMat, TimeMat] = calcrange(SpotPrice, TimeExpiry, VizRange);
     
     %Call the BLSPRICE function to value the call option
     CallValue = blsprice(SpotMat, StrikePrice, RiskFreeRate, TimeMat,...
          Volatility);
     
     %Plot the resulting value surface
     figure(OutHandle);
     hqr=surf(SpotMat, TimeMat, CallValue, gradient(CallValue, diff(SpotMat(1,1:2)), diff(TimeMat(1:2))));
     xlabel('Spot Price');
     ylabel('Time to Expiry');
     zlabel('Option Value');
     title('Call Option');
     surfOptions(hqr);
     
elseif (~ErrorFlag && OptionType == 2) %Put option
     
     %Compute ranges for the spot price and time to expiry based on the
     %specified visualization range
     [SpotMat, TimeMat] = calcrange(SpotPrice, TimeExpiry, VizRange);
     
     %Price the option over the ranges
     [Temp, PutValue] = blsprice(SpotMat, StrikePrice, ...
          RiskFreeRate, TimeMat, Volatility);
     
     %Plot the resulting value surface
     figure(OutHandle);
     hqr = surf(SpotMat, TimeMat, PutValue, gradient(PutValue, diff(SpotMat(1,1:2)), diff(TimeMat(1:2))));
     xlabel('Spot Price');
     ylabel('Time to Expiry');
     zlabel('Option Value');
     title('Put Option');
     surfOptions(hqr);
          
elseif (~ErrorFlag && OptionType == 3) %Straddle option
     
     %Compute ranges for the spot price and time to expiry based on the
     %specified visualization range
     [SpotMat, TimeMat] = calcrange(SpotPrice, TimeExpiry, VizRange);
     
     %Price the option over the ranges
     StraddleValue = blsstrval(SpotMat, StrikePrice, ...
          RiskFreeRate, TimeMat, Volatility);
     
     %Plot the resulting value surface
     figure(OutHandle);
     hqr = surf(SpotMat, TimeMat, StraddleValue, gradient(StraddleValue, diff(SpotMat(1,1:2)), diff(TimeMat(1:2))));
     xlabel('Spot Price');
     ylabel('Time to Expiry');
     zlabel('Option Value');
     title('Straddle Option');
     surfOptions(hqr);
     
elseif (~ErrorFlag && OptionType == 4) %Butterfly option
     
     %Compute ranges for the spot price and time to expiry based on the
     %specified visualization range
     [SpotMat, TimeMat] = calcrange(SpotPrice, TimeExpiry, VizRange);
     
     %Get the butterfly range
     Handle = findobj(gcbf, 'Tag', 'EditButterflyRange');
     ButterflyRange = str2double(get(Handle, 'String'));
     
     %Price the option over the ranges
     ButterflyValue = blsbtyval(SpotMat, StrikePrice, RiskFreeRate, ...
          TimeMat, Volatility, ButterflyRange);
     
     %Plot the resulting value surface
     figure(OutHandle);
     hqr = surf(SpotMat, TimeMat, ButterflyValue, gradient(ButterflyValue, diff(SpotMat(1,1:2)), diff(TimeMat(1:2))));
     xlabel('Spot Price');
     ylabel('Time to Expiry');
     zlabel('Option Value');
     title('Butterfly Option');
     surfOptions(hqr);     
end

%end of VIZROUTINE subroutine

%-----------------------------------------------------------------------------
function [ErrorFlag, OptionType, SpotPrice, StrikePrice, RiskFreeRate, ...
          TimeExpiry, Volatility, VizRange] = getguidata()
%GETGUIDATA Get all data from GUI and perform error checking

%Get the input arguments

%Get the spot price
SpotHandle = findobj('Tag', 'EditSpotPrice');
SpotPrice = str2double(get(SpotHandle, 'String'));

%Get the strike price
StrikeHandle = findobj('Tag', 'EditStrikePrice');
StrikePrice = str2double(get(StrikeHandle, 'String'));

%Get the risk free rate of return
RateHandle = findobj('Tag', 'EditRiskFreeRate');
RiskFreeRate = str2double(get(RateHandle, 'String'));

%Get the time to expiry
TimeHandle = findobj('Tag', 'EditTimeExpiry');
TimeExpiry = str2double(get(TimeHandle, 'String'));

%Get the volatility
VolatilityHandle = findobj('Tag', 'EditVolatility');
Volatility = str2double(get(VolatilityHandle, 'String'));

%Get the visualization range
VizRangeHandle = findobj('Tag', 'EditVisualizationRange');
VizRange = str2double(get(VizRangeHandle, 'String'));

%Get the type of option being priced
DataStruct = get(findobj('Name','Option Pricing Tool'),'UserData');
OptionType = DataStruct.OptionType;

%Check input arguments and report errors
ErrorFlag = 0;
if (isempty(SpotPrice) || SpotPrice <= 0)
     ErrorFlag = 1;
     errordlg('Spot price cannot be empty, zero or negative!')
end
if (isempty(StrikePrice) || StrikePrice <= 0)
     ErrorFlag = 1;
     errordlg('Strike price cannot be empty, zero or negative!')
end
if (isempty(RiskFreeRate) || RiskFreeRate < 0)
     ErrorFlag = 1;
     errordlg('Risk free rate cannot be empty or negative!')
end
if (isempty(TimeExpiry) || TimeExpiry < 0)
     ErrorFlag = 1;
     errordlg('Time to expiry cannot be empty or negative!')
end
if (isempty(Volatility) || Volatility < 0)
     ErrorFlag = 1;
     errordlg('Volatility cannot be empty or negative!')
end
if (isempty(OptionType))
     ErrorFlag = 1;
     errordlg('You must specify an option type!')
end
if (isempty(VizRange) || VizRange <= 0)
     ErrorFlag = 1;
     errordlg('You must specify a visualization range!')
end

%end of GETGUIDATA subroutine

%-----------------------------------------------------------------------------
function [SpotMat, TimeMat] = calcrange(SpotPrice, TimeExpiry, VizRange)
%CALCRANGE Compute spot price and time to expiry range based on visualization
%range

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

%-----------------------------------------------------------------------------
function StraddleValue = blsstrval(SpotPrice, StrikePrice, RiskFreeRate, ...
          TimeExpiry, Volatility)
%BLSSTRVAL Black Scholes value of a straddle option

%Calculate the value of both the call and put option
[CallValue, PutValue] = blsprice(SpotPrice, StrikePrice, RiskFreeRate, ...
     TimeExpiry, Volatility);

%Compute the value of the straddle
StraddleValue = CallValue + PutValue;

%end of BLSSTRVAL subroutine

%-----------------------------------------------------------------------------
function ButterflyValue = blsbtyval(SpotPrice, StrikePrice, RiskFreeRate, ...
          TimeExpiry, Volatility, ButterflyRange)
%BLSBTYVAL Black Scholes value of a butterfly option

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

%end of BLSBTYVAL subroutine






