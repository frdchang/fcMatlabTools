function [ nDData ] = convertLinearDomainToND( linearDomains,linearData)
%CONVERTLINEARDOMAINTOND a linear domain with linear data will be converted
%to its NDform and padded with NaN

minDom = min([linearDomains{:}]);
maxDom = max([linearDomains{:}]);

indices = num2cell(bsxfun(@minus,[linearDomains{:}],minDom)+1,1);


if iscell(linearData)    
    nDData = cell(numel(linearData),1);
    [nDData{:}] = deal(NaN(maxDom-minDom+1));
    linearIndices = sub2ind(size(nDData{1}),indices{:});
    for ii = 1:numel(linearData)
       nDData{ii}(linearIndices) = linearData{ii}; 
    end
    
else
    nDData = NaN(maxDom-minDom+1);
    linearIndices = sub2ind(size(nDData),indices{:});
    nDData(linearIndices) = linearData;
end



