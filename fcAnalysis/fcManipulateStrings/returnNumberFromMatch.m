function yourNumberAfterYourText = returnNumberFromMatch(str,theTextBeforeNumber,theTextAfterNumber)
%RETURNNUMBERFROMMATCH returns the number that exists right before
%theTextBeforeNumber using regexp. 

matchTheText = regexp(str,[theTextBeforeNumber '[0-9]+' theTextAfterNumber],'match');
number = regexp(matchTheText,'[0-9]+','match');
yourNumberAfterYourText = str2double(number{1});

end

