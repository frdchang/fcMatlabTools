function montaged = montageAlignment(dataCell)
%MONTAGEALIGNMENT Summary of this function goes here
%   Detailed explanation goes here

% find the maximum size that exists in datacell
lengthMax = max(cell2mat(cellfunNonUniformOutput(@(x) size(x,1),dataCell)));
montaged = zeros(lengthMax,numel(dataCell));

for ii = 1:numel(dataCell)
    display(ii)
    currData = dataCell{ii};
    lengthData = numel(currData);
    startVal = round((lengthMax - lengthData)/2)+1;
    endVal   = startVal + lengthData-1;
    montaged(startVal:endVal,ii) = currData;
end

montaged = montaged';

