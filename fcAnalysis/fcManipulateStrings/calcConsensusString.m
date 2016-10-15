function consensusString = calcConsensusString(listOfStrings)
%CALCCONSENSUSSTRING will go through the list of strings and return the
%consensus string.  unique characters will be displayed in brackets.  if
%the strings have different length, this function will do the consensus up
%to the shortest one.

if ~iscell(listOfStrings)
    consensusString = listOfStrings;
   return; 
end

numElements = min(cellfun(@(x) numel(x),listOfStrings));
consensusString = '';
for ii = 1:numElements
    consensChar = unique(cellfun(@(x) x(ii), listOfStrings));
    if numel(consensChar) > 1
        if sum(~isstrprop(consensChar,'digit')) == 0
            % they are all digits
            theDigits = str2num(consensChar);
            minDigit = num2str(min(theDigits));
            maxDigit = num2str(max(theDigits));
            jumpDigit = num2str(mean(diff(theDigits)));
            consensChar = ['|' minDigit '<' jumpDigit '>' maxDigit '|'];
        else
        consensChar = ['|' consensChar' '|'];
        end
    end
    consensusString = [ consensusString consensChar];
end


