function [ montaged ] = genMontage( cellOfData,varargin)
%GENMONTAGE will make a montage given a cell of datas and even if they are
%different sizes.  it normalizes all the datas to uint8

%--parameters--------------------------------------------------------------
params.border      = 2;
params.borderColor = 50;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

cellOfData = flattenCellArray(cellOfData);
cellOfData = cellfunNonUniformOutput(@norm2UINT255,cellOfData);

sizeDatas  = cellfunNonUniformOutput(@size,cellOfData);
xSize = max(cellfun(@(x) x(1),sizeDatas));
ySize = max(cellfun(@(x) x(2),sizeDatas));
temp = ones(xSize,ySize);
tempBorder = params.borderColor*ones(params.border,ySize);
numDatas = numel(cellOfData);

totalMontages = numDatas + (numDatas-1);
montaged = cell(totalMontages,1);
dataIndex = 1;
for ii = 1:totalMontages
    if isodd(ii)
        currData = cellOfData{dataIndex};
        currSize = size(currData);
        temp(:,:) = params.borderColor;
        temp(1:currSize(1),1:currSize(2)) = currData;
        montaged{ii} = temp;
        dataIndex = dataIndex + 1;
    else
        montaged{ii} = tempBorder;
    end
end

end

