function [ HistRowNumAll, AllHistData ] = CleanHistoryData( HistRowNumAll, AllHistData )
%CLEANHISTORYDATA 
% Cleans data set recorded by GetHistory.m for additional analysis
% Removes all zeros from matrices and lines everything up

% find non-zero elements -- returns position of matrix elements 
k = find(HistRowNumAll);
HistRowNumAll = HistRowNumAll(k);

% re-shape into history number and time values 
HistRowNumAll = reshape(HistRowNumAll,2,[]);
HistRowNumAll = transpose(HistRowNumAll); 

RowNumAll = length(AllHistData);  % Need to find rows length, columns length changes 

% Do the same for AllHistData
k = find(AllHistData);
AllHistData = AllHistData(k);
AllHistData = reshape(AllHistData,RowNumAll,[]);

% The last values in both data sets are repeats (needed to stop the History
% read out). Delete them here. 

HistRowNumAll = HistRowNumAll(1:(size(HistRowNumAll,1)-1),:);
AllHistData = AllHistData(:,1:(size(AllHistData,2)-1));

% Normalise the second column of HistRowNumAll -- to a time unit (ms) 

HistRowNumAll(:,2) = (HistRowNumAll(:,2)-HistRowNumAll(length(HistRowNumAll),2))./100;

end 