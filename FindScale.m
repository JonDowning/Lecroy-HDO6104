function FindScale(Channel,DSO)
% FINDSCALE select channel to Autoscale to minium value

% I don't think the oscilloscope does this very well, often there are
% division left towards the lower end of the sensitivity. i.e. oscilloscope
% selects 5 mV when 2 mV would be more appropriate 

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

FindScaleStr = ['VBS app.Acquisition.',Channel,'.FindScale'];
invoke(DSO,'WriteString',FindScaleStr,true); 

% Let's make the function push to higher accuracy 
ReturnScaleStr = ['VBS? return = app.Acquisition.',Channel,'.VerScale'];
invoke(DSO,'WriteString',ReturnScaleStr,true); 
Scale=invoke(DSO,'ReadString',1000); 

Scale = str2num(Scale);
Scale = Scale - 0.004; % If Scale is less than 0, osci uses lowest value possible 1 mV
% Also osci will auto bin the closest scale value -- 1, 2, 5, 10 mV etc.. 
Scale = num2str(Scale); 

SetScaleString = ['VBS app.Acquisition.',Channel,'.VerScale =','"', Scale,'"'];
str = ['SetScale string to oscilloscope is: ', SetScaleString];
disp(str)
invoke(DSO,'WriteString',SetScaleString,true); 

end

