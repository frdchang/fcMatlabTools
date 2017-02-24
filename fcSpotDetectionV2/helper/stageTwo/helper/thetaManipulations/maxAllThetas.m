function maxThetas = maxAllThetas(thetaInputs)
%MAXALLTHETAS will generate a set of ones that mirror the input of
%thetaInputs

numThetas = numel(thetaInputs);
maxThetas = cell(1,numThetas);
for ii = 1:numThetas
    currInpute = thetaInputs{ii};
    if isscalar(currInpute)
       maxThetas{ii} = 1; 
    else
       argumentList = currInpute{2:end};
       maxThetas{ii} = ones(size(argumentList));
    end
end


end

