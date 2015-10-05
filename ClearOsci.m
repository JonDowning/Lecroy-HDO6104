function ClearOsci(DSO)

invoke(DSO,'WriteString','VBS app.Acquisition.ClearSweeps',true);  % Clear stored sweeps

% invoke(DSO,'WriteString','VBS app.Display.ClearSweeps',true); % Clear sweeps from display

% Turn off all traces
invoke(DSO,'WriteString','C1:TRA OFF',true); % Turn channel 1 off 
invoke(DSO,'WriteString','C2:TRA OFF',true); % Turn channel 2 off 
invoke(DSO,'WriteString','C3:TRA OFF',true); % Turn channel 3 off 
invoke(DSO,'WriteString','C4:TRA OFF',true); % Turn channel 4 off 

invoke(DSO,'WriteString','F1:TRA OFF',true); % Turn function 1 off 
invoke(DSO,'WriteString','F2:TRA OFF',true); % Turn function 2 off 

invoke(DSO,'WriteString','Z1:TRA OFF',true); % Turn Z1 off 
invoke(DSO,'WriteString','Z2:TRA OFF',true); % Turn Z2 off 


end
