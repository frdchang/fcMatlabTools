function listOfListofArguemnts = convertListToListofArguments(listOfFiles)
%CONVERTLISTTOLISTOFARGUMENTS Summary of this function goes here
%   Detailed explanation goes here

listOfListofArguemnts = cellfunNonUniformOutput(@(x) {x},listOfFiles);
end

