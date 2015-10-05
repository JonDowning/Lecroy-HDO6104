function [GridMode] = DisplayConfig(DSO) 

invoke(DSO,'WriteString','GRID SINGLE',true); % I like single but can choose, dual or quad -- This is GPIB code 

% Examples of code that works to the same effect:  
% invoke(DSO,'WriteString','VBS app.Display.GridMode = "single"',true) --
% this is VBS code 
% invoke(DSO,'WriteString','VBS app.Display.GridMode = 1',true) -- 1
% refers to the first option in the list of variables

% Example of query in GPIB
% invoke(DSO,'WriteString','GRID?',true); 
% TestParameter=invoke(DSO,'ReadString',1000)  

% Example of query in VBS 
% invoke(DSO,'WriteString','VBS? return = app.Display.GridMode',true);
% TestParameter=invoke(DSO,'ReadString',1000) 


invoke(DSO,'WriteString','VBS app.SpecAnalyzer.Enable = 0',true); % Turn off SpecAnalyzer, use boolian values where you can. 


invoke(DSO,'WriteString','VBS app.Display.DisplayMode = "Scope"',true); % Setup for Scope 

end 