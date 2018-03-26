function [kept] = keepOrderedStrings(cellOfStrings,cellofRegexpKeys)
%KEEPORDEREDSTRINGS will return the the set of strings matched by the
%corresponding regexpkey with the additional property that the left over
%parts can be matched, will be matched.  this is important for those cases
%in which you want to extract out n colors from the whole list of file
%names, and the rest of the file name is identical.

numCells = numel(cellofRegexpKeys);

for ii = 1:numCells
   currentMatched = regexp(cellOfStrings,cellofRegexpKeys{ii},'split');
   notKeepers = cellfun(@(x,y) numel(x{1}) == numel(y),currentMatched,cellOfStrings);
   currentMatched(notKeepers) = [];
   history = cellfun(@(x) strjoin(x,''),currentMatched);
end

end

