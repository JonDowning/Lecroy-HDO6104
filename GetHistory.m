function [ HistRowNumAll, AllHistData ] = GetHistory(Channel, Sweeps, Freq, DSO)
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

% Clear History of previous data 1 
invoke(DSO,'WriteString','VBS app.ClearSweeps', true)
invoke(DSO,'WriteString','VBS app.Math.ClearSweeps', true)

uiwait(msgbox('When you click okay data collection will start','Collect Data','modal'));

% Clear History of previous data 2 
invoke(DSO,'WriteString','VBS app.ClearSweeps', true)

disp('Data collection started')
tic

% This needs optomising. 
PauseTime = 1.2*Sweeps/Freq; % There is some setup time for the scope to initialise.. 

% Oscilloscope needs to be started so that data is 
invoke(DSO,'WriteString','VBS app.TriggerScan.StartScan',true)

pause(PauseTime)

% Stop Oscilloscope 
invoke(DSO,'WriteString','VBS app.TriggerScan.StopScan',true)
pause(1)
invoke(DSO,'WriteString','VBS app.History.Enable = 1',true); % Need to turn history on.. 
invoke(DSO,'WriteString','VBS app.History.ViewTable = 1',true);

disp('Data collection finished')
toc


tic
disp('Now reading data from oscilloscope')



% Now to Collect all data 
% How many history values are there? Can't get this out.. 

% invoke(DSO,'WriteString','VBS app.History.SelTableRow = 1',true)

% Assume anything on screen matches to history.. 

% The highest number is the first to be read
% Lowest is the last.. Start at lowest then read up to highest.
% There seems to be no way for the range to be read out so will have to
% compare to previous time History Row Numbers. 

% First read out the initial data to get a size for the matrix 
Plot = 0; % don't plot the data 
[ChannelData] = GetWaveForm(Channel,Plot,DSO);
MatrixSize = length(ChannelData);

HistRowNum = 0;
HistRowNumAll = zeros(2,1000);

% I have no idea how large the data set is. 
%Look to make a large matrix then remove the zeros later
AllHistData = zeros(MatrixSize, 1000);

ChannelData = [];

for ii = 1:1000;
    % Selects rows and determines whether we're at the end of the
    % HistoryTable 
    
    strii = num2str(ii);
    SelTableStr = ['VBS app.History.SelTableRow = ',strii,''];
    
    invoke(DSO,'WriteString',SelTableStr,true);
     pause(1) 
	invoke(DSO,'WriteString','VBS? return = app.History.SelTableRow',true); 
    HistRowNum = invoke(DSO,'ReadString',1000);
    disp(['Code to Osci is: ', SelTableStr]);
    disp(['HistRow is: ', HistRowNum]);
     
    % Lets put the collection time values next to the HistRowNumbers.. 
    invoke(DSO,'WriteString','VBS? return = app.Acquisition.C1.Out.Result.FirstEventTime',true);
	CollectionTime = invoke(DSO,'ReadString',1000);
   
    
    HistRowNum = str2num(HistRowNum);
    CollectionTime = str2num(CollectionTime);
      
    HistRowNumAll(1,ii+1) = HistRowNum;
    HistRowNumAll(2,ii+1) = CollectionTime;
    
    [channeldata] = GetWaveForm(Channel,Plot,DSO);
    pause(0.1)  % I don't know if this is needed.. 
    disp(['Data from: ',num2str(HistRowNum),' was saved']);
    
    if ii == 1;
        time = channeldata(:,1);
        AllHistData(:,1) = time;
        AllHistData(:,ii+1) = channeldata(:,2);
    end 
    
    % The rest of the data is sequentially aggregated into the AllHistData
    % Matrix. 
    AllHistData(:,ii+1) = channeldata(:,2); 
        
    if HistRowNumAll(1,ii+1) == HistRowNumAll(1,ii);
        break 
    end 
end
    
   
% Does break terminate function? -- Yes. This never gets printed. 
disp('Made it to the end')

% Run secondary function to clean data. 

toc 


end

