function [ output_args ] = getCompactTimePoints( cellOfNumbersStrings )
%GETCOMPACTTIMEPOINTS given a cell array of string numbers, this will get a
%compact string representation of it

numbers = regexp(cellOfNumbersStrings,'^[0-9]+$','match');
idxNums = ~cellfun(@isempty,numbers);
if idxNums==0
   output_args = cellOfNumbersStrings;
   return;
end
numbers = cellOfNumbersStrings(idxNums);
numbers = cellfun(@str2double,numbers);
numbers = sort(numbers);

diffNums = unique(diff(numbers));
if diffNums==1
   output_args = [num2str(numbers(1)) '-' num2str(numbers(end))] ;
else
   output_args = [num2str(numbers(1)) '-' mat2str(diffNums) '-' num2str(numbers(end))] ;
end

cellOfNumbersStrings(idxNums) = [];
output_args = {cellOfNumbersStrings{:}, output_args};

end

