function appliedInvKmatrix = applyInvKmatrix(invKmatrix,cellDataArray)
%APPLYINVKMATRIX 


appliedInvKmatrix = cell(size(cellDataArray));

for ii = 1:numel(appliedInvKmatrix)
    appliedInvKmatrix{ii} = zeros(size(cellDataArray{1}));
end


for ii = 1:numel(appliedInvKmatrix{1})
    transformed = invKmatrix*cellfun(@(x) x(ii),cellDataArray);
    for jj = 1:numel(transformed)
       appliedInvKmatrix{jj}(ii) = transformed(jj); 
    end
end


