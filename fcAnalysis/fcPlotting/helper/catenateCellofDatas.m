function catDatas = catenateCellofDatas(cellOfDatas)
%CATENATECELLARRAYS Summary of this function goes here
%   Detailed explanation goes here
catDatas = cellOfDatas{1};
for ii = 2:numel(cellOfDatas)
    catDatas = horzcat(catDatas,cellOfDatas{ii});
end
end

