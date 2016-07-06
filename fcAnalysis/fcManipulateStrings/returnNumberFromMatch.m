function yourNumberAfterYourText = returnNumberFromMatch(str,theTextBeforeNumber,theTextAfterNumber)
%RETURNNUMBERFROMMATCH returns the number that exists right before
%theTextBeforeNumber using regexp. 

matchTheText = regexp(str,[theTextBeforeNumber '[0-9]+' theTextAfterNumber],'match');
yourNumberAfterYourText = str2double(regexp('A10','[0-9]+','match'));

end

