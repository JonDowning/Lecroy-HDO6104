% This Matlab script transfers data between a LeCroy XStreamDSO scope (HDO6104) and
% Matlab (either running on a separate computer or residing on the scope)
% using ActiveDSO via USB on IVI driver 

% Author: Jon Downing (NIST)
% Version: 1.1 
% Date: October 2015 

% Instructions: 
% Install ActiveDSO on computer or scope, set scope USB as on scope under utilities/utilities setup/remote
% NI-VISA must also be installed and the scope should the autoconfigure on
% a driver that called USB Test and Measurement Device (IVI) 

% This script sends ActiveX and GPIB commands to the osci. ActiveX commands
% are prefaced with VBS and add additional functionality. A complete list
% with variables can be found in the Xstream Browser which is run from the desktop of the oscilloscope

% Users must make a manual connection to the oscilloscope. 
% First run: 
DSO = actxcontrol('LeCroy.ActiveDSOCtrl.1', [0 0 800 500], gcf); % Load ActiveDSO control

% Then right click on the black box in the figure and choose make connection
% Select USB and it should also choose the right path. It will be something like this -- USB0:0x05FF:0x1023:3561N18043:INSTR

% Below are a list of the functions for the oscilloscope -- 

[ID] = CheckIDN(DSO)
% Check is a connection is present, outputs the oscilloscope ID

[GridMode] = DisplayConfig(DSO)
% Configures the oscilloscope for use as an oscilloscope. i.e. not a spectrum analyzer

ClearOsci(DSO)
% Clears traces on all channels. 

FindScale(Channel,DSO)
% FINDSCALE select channel to Autoscale to minium value
% I don't think the oscilloscope does this very well, often there are
% division left towards the lower end of the sensitivity. i.e. oscilloscope
% selects 5 mV when 2 mV would be more appropriate. Line 33 allows you some flexibility here.. 

[channeldata] = GetWaveForm(Channel,Plot,DSO)
%GETWAVEFORM Grab waveform data with ActiveX component 
% Select Channel as str (for example 'C1') -- currently only one channel can be read out.. 
% Plot is boolian, if 1 then data will be plotted into new figure. 

[AverageData] = AverageAndGetWaveForm(Channel, AverLength, Freq, Plot, DSO)
% AVERAGEANDGETWAVEFORM 
% Pick channel and conduct average over set number of scans
% After averaging, data is read out and saved in text file (to add).. 
% User can pick the channel for averaging but not the function number -- script always points to F1
% Currently averaging is set to summed -- starts at zero and stops when the
% total number of sweeps (AverLength) is reached. Time to wait for the
% instrument is calculated from AverLength*Freq

%SAVEFROMHIST 
% This script turns on the history and clear all previous data
% The user is then asked if data is ready to be collected. This is done for
% a fixed amount of time (Sweeps/Freq) before data is read from the History
% Table into an array (AllHistData), timing is also recorded from the
% oscilloscope and is the first column of the array (AllHistData). 
% The array HistRowNumAll records history number and time. Here the final
% row is the earliest time and all other negative to represent this fact. 

% Running data collection in this fashion is desirable because a) no data
% is lost in the averagin process, which maybe useful is C1 and C2 are
% correlated in time b) the oscilloscope can save data to the memory /
% history faster than it can over USB to the computer. Thus using the
% History function may speed up the measurement time (although not
% necessarily the processing time!)


%CLEANHISTORYDATA 
% Cleans data set recorded by GetHistory.m for additional analysis
% Removes all zeros from matrices and lines everything up
