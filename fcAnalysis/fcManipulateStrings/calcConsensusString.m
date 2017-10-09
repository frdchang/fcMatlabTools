function [consensusString,idxmatch] = calcConsensusString(listOfStrings)
%CALCCONSENSUSSTRING will go through the list of strings and return the
%consensus string.  unique characters will be displayed in brackets.  if
%the strings have different length, this function will do the consensus up
%to the shortest one.

if ~iscell(listOfStrings)
    consensusString = listOfStrings;
    return;
end

if isempty(listOfStrings)
   consensusString = '';
   idxmatch = [];
   return;
end
numElements = min(cellfun(@(x) numel(x),listOfStrings));
consensusString = '';
idxmatch = zeros(numElements,1);
for ii = 1:numElements
    consensChar = unique(cellfun(@(x) x(ii), listOfStrings));
    if numel(consensChar) > 1
        %         if sum(~isstrprop(consensChar,'digit')) == 0
        %             % they are all digits
        %             theDigits = str2num(consensChar);
        %             minDigit = num2str(min(theDigits));
        %             maxDigit = num2str(max(theDigits));
        %             jumpDigit = num2str(mean(diff(theDigits)));
        %             consensChar = ['|' minDigit '<' jumpDigit '>' maxDigit '|'];
        %         else
        %         consensChar = ['|' consensChar' '|'];
        %         end
%         consensusString = [ consensusString 'x'];
    else
        consensusString = [ consensusString consensChar];
        idxmatch(ii) = 1;
    end
end

if idxmatch(1) == 0
   consensusString = '';
   idxmatch = zeros(numElements,1);
end
end



