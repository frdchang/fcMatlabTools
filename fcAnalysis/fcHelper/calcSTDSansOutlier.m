function [ output ] = calcSTDSansOutlier( data )
%CALCSTDSANSOUTLIER will calculated std without outlier

data = data(:);

[idx] = isoutlier(data);

data(idx) = [];

output = std(data);


end

