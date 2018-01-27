%% Import data from text file.
% Script for importing data from the following text file:
%
%    C:\Work\Seminar\MATLAB for R Users\Demos\1_Interact\priceData.csv
%
% To extend the code to different selected data or a different text file,
% generate a function instead of a script.

% Auto-generated by MATLAB on 2013/06/25 09:00:37
% Copyright 2013 MathWorks, Inc.

%% Initialize variables.
filename = 'C:\Work\Seminar\MATLAB for R Users\Demos\1_Interact\priceData.csv';
delimiter = ',';
startRow = 6;

%% Format string for each line of text:
%   column1: text (%s)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
%	column6: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%f%f%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
priceData = dataset(dataArray{1:end-1}, 'VarNames', {'Date','Hour','DA_EC','DA_CC','DA_MLC','RT_LMP'});
%% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans;