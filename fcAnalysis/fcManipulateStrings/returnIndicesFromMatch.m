function indices = returnIndicesFromMatch(matchThisList,fromThisList)
%RETURNINDICESFROMMATCH will take matchThisList as the master index
%position and get it fromThisList using a strcmp

numElements = numel(fromThisList);
indices = zeros(numElements,1);

for i = 1:numElements
    foundItHere = find(strcmp(fromThisList{i},matchThisList));
    if isempty(foundItHere)
        indices(i) = NaN;
    elseif numel(foundItHere) > 1
        error('duplicate entries found');
    else
        indices(i) = foundItHere;
    end
end

