function [Result,idx] = threshAtTopPercent(data,myPercent)
%THRESHATTOPPERCENT will return data points that correspond to the top
%myPercent
[data_sorted,idx] = sort(data(:),'descend');                          % Sort Descending
takeThese  =1:ceil(length(data_sorted)*myPercent);
Result = data_sorted(takeThese);                % Desired Output
idx = idx(takeThese);
end

