function s = recursivesum(v)
% v is a (possibly nested) cell array and sums
s=0; % initial value of sum
for i=1:length(v)
    if isnumeric(v{i})
        % this is the terminal step
        s = s + sum(v{i});
    else
        % we got another cell, so we recurse
        s = s + recursivesum(v{i});
    end
end
