function s = recursiveFuncOnCell(func,myCell)
% v is a (possibly nested) cell array and sums
s=0; % initial value of sum
for i=1:length(myCell)
    if isnumeric(myCell{i})
        % this is the terminal step
        s = s + func(myCell{i});
    else
        % we got another cell, so we recurse
        s = s + recursivesum(myCell{i});
    end
end
