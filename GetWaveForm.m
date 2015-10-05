function [channeldata] = GetWaveForm(Channel,Plot,DSO)
%GETWAVEFORM Grab waveform data with ActiveX component 
% Select Channel as str -- currently only one channel can be read out.. 
% Plot is boolian, if 1 then data will be plotted into new figure. 

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

channeldata=invoke(DSO,'GetScaledWaveformWithTimes',Channel,10000000,0); % Get Wavefrom Data - Channel, points -- I don't know what the final variable does.. 
channeldata=double(channeldata); % ActiveDSO transfers single precision matrix.  Need to convert to double to plot in Matlab. 
channeldata = transpose(channeldata);

% If you want all channel data write this function (GetWaveForm) into a loop! See (GetHistory.m) 

if Plot == 1
    
    ChannelStr = ['Data from channel: ', Channel];
    figure
    plot(channeldata(:,1),channeldata(:,2));
    xlabel('Time (s)');
    ylabel('Voltage (V)');
    legend(ChannelStr)
end 


end

