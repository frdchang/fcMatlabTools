function firstField = loadAndTakeFirstField(filepath)
%LOADANDTAKEFIRSTFIELD Summary of this function goes here
%   Detailed explanation goes here

firstField = load(filepath);
daFields = fieldnames(firstField);
firstField = firstField.(daFields{1});
end

