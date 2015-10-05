% Write time base -- this can be with units NS, US, MS, S as required

% TimeBase should be a double
% Unit must be a string and can only be one of the following: NS, US, MS, S

function SetTimeBase(TimeBase, Unit,DSO)

% Check user has entered appropriate values for time base
if isnumeric(TimeBase) == 1 
    disp('Timebase is numeric -- good!')
else 
    disp('Timebase must be numeric -- please re-enter value')
    return
end


% Check user has entered appropriate values for unit

Unit = upper(Unit); % First convert to all caps

if ischar(Unit) == 1
    disp('Unit is a char -- good!')
else 
    disp('Unit is not char -- please re-enter value')
    return 
end

if Unit == 'NS' | Unit == 'US' | Unit == 'MS' | Unit == 'S' 
     disp('Unit has the correct value -- good!')
else 
    disp('Unit is not NS, US, MS or S -- please re-enter value')
    return
end
        
TimeBaseStr = ['TDIV ', num2str(TimeBase), ' ', Unit];
disp('Timebase string to oscilloscope is: ', TimeBaseStr)

invoke(DSO,'WriteString',TimeBaseStr,true); 

% invoke(DSO,'WriteString','TDIV 5 MS',true) -- GPIB example

end 