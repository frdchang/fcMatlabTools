function [ sizeData ] = getSize(data )
%GETSIZE sometimes data is a numeric, sometimes data is a cell array.  if
%it is a cell array, i want the numeric data size.  

if iscell(data)
    data = flattenCellArray(data);
   sizeData = size(data{1});
else
   sizeData = size(data);
end


end

