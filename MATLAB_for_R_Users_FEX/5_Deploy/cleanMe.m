% cleanMe: cleans the directory structure for future runs of BLSAPP
%
% Many files are created by the compiler, either when you create a
% standalone executable or when you make an Excel add-in.  This file
% removes them all and makes the directory suitable for the next
% demonstration.

% Copyright 2013 MathWorks, Inc.

 delete *.c
 delete *.exe
 delete *.txt
 delete *.prj
 delete *.log
 try
    rmdir('Untitled*', 's')
 catch
 end