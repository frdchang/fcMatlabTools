function listOfListofArguemnts = convertListToListofArguments(listOfFiles)
%CONVERTLISTTOLISTOFARGUMENTS Summary of this function goes here
%   Detailed explanation goes here
if isempty(listOfFiles)
   listOfListofArguemnts = [];
   return;
end
listOfListofArguemnts = cellfunNonUniformOutput(@(x) {x},listOfFiles);
end

