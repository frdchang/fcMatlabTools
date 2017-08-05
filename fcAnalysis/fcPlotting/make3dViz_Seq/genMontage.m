function [ montaged ] = genMontage( cellOfData,varargin)
%GENMONTAGE will make a montage given a cell of datas and even if they are
%different sizes.

%--parameters--------------------------------------------------------------
params.border      = 2;
params.borderColor = 50;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

cellOfData = flattenCellArray(cellOfData);
% cellOfData = cellfunNonUniformOutput(@norm2UINT255,cellOfData);

sizeDatas  = cellfunNonUniformOutput(@size,cellOfData);
xSize = max(cellfun(@(x) x(1),sizeDatas));
ySize = max(cellfun(@(x) x(2),sizeDatas));
temp = ones(xSize,ySize,3);
tempBorder = params.borderColor*ones(params.border,ySize,3);
numDatas = numel(cellOfData);

totalMontages = numDatas + (numDatas-1);
montaged = cell(totalMontages,1);
dataIndex = 1;
for ii = 1:totalMontages
    if isodd(ii)
        currData = cellOfData{dataIndex};
        if isempty(currData)
           continue; 
        end
        currSize = size(currData);
        temp = params.borderColor*ones(currSize(1),ySize,3);
        if numel(currSize) == 2
            temp(1:currSize(1),1:currSize(2),:) = repmat(currData,1,1,3);
        else
            temp(1:currSize(1),1:currSize(2),:) = currData;
        end
        montaged{ii} = temp;
        dataIndex = dataIndex + 1;
    else
        montaged{ii} = tempBorder;
    end
end

montaged = cell2mat(montaged);
montaged = uint8(montaged);
end

