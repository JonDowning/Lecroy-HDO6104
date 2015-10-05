function [AverageData] = AverageAndGetWaveForm(Channel, AverLength, Freq, Plot, DSO)
% AVERAGEANDGETWAVEFORM 
% Pick channel and conduct average over set number of scans
% After averaging, data is read out and saved in text file (to add).. 
% User can pick the channel for averaging but not the function number --
% script always points to F1

% Currently averaging is set to summed -- starts at zero and stops when the
% total number of sweeps (AverLength) is reached. Time to wait for the
% instrument is calculated from AverLength*Freq


Channel = upper(Channel);  % Capital letters are best

if ischar(Channel) == 1 
    disp('Channel is char -- good!')
else 
    disp('Channel must be char -- please re-enter value')
    return
end

if Channel == 'C1' | Unit == 'C2' | Unit == 'C3' | Unit == 'C4' 
     disp('Channel has an appropriate value -- good!')
else 
    disp('Channel must be either C1, C2, C3 or C4 -- please re-enter value')
    return
end


% Turn on function trace 
invoke(DSO,'WriteString','F1:TRA ON',true); % Turn function 1 off 

% Define function trace 
% FunctionStr = ['VBS app.Math.F1.EquationRemote = "AVG(',Channel,')"'];  % For some reason this script doesn't work

FunctionStr =  ['F1:DEF EQN,"AVG(C1)"'];
disp(['Set F1 to Averaging string to oscilloscope is: ', FunctionStr])

invoke(DSO,'WriteString',FunctionStr,true); 

% Let's label the function too
F1LabelStr = ['VBS app.Math.F1.LabelsText = "',AverLength,' sweep average of ',Channel,'"'];
invoke(DSO,'WriteString',F1LabelStr,true); 

% Choose whether summed or coninteous, for our purposes summed is best
AverageTypeStr = ['VBS app.Math.F1.Operator1Setup.AverageType = "Summed"'];

invoke(DSO,'WriteString',AverageTypeStr,true); 

% Define length of averaging 
AverLength = num2str(AverLength);
FunctionSweepsStr = ['VBS app.Math.F1.Operator1Setup.Sweeps = ',AverLength,''''];
disp(['Number of averages string to oscilloscope is: ', FunctionSweepsStr])

invoke(DSO,'WriteString',FunctionSweepsStr,true); 

% Clear previous sweeps 
invoke(DSO,'WriteString','VBS app.Math.F1.Operator1Setup.ClearSweeps',true); 


% Do we need to wait for data to be collected? 
% Yes! 

% Calculate how long it will take for all data to be collected and averaged
DelayTime = 1.1*str2num(AverLength)/Freq; % include 10 % overhead, may need more.. 
disp(['Time to wait between starting measurement and saving data: 'DelayTime);
pause(DelayTime); 

AverageData=invoke(DSO,'GetScaledWaveformWithTimes','F1',1000000,0); % Get Wavefrom Data - Channel, points 

AverageData=double(AverageData); % ActiveDSO transfers single precision matrix.  Need to convert to double to plot in Matlab. 
AverageData = transpose(AverageData);

ChannelStr = ['Data from channel: ', Channel, ' (Averaged over ', AverLength, ' sweeps)'];

if Plot == 1
figure
plot(AverageData(:,1),AverageData(:,2));
xlabel('Time (s)');
ylabel('Voltage (V)');
legend(ChannelStr)
end 

end

