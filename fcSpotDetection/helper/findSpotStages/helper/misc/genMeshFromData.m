function meshBasket = genMeshFromData(data)
%GENMESHFROMDATA will gen mesh from data

meshBasket = cell(ndims(data),1);
gridInputs = cellfunNonUniformOutput(@(x) [1:x],num2cell(size(data)));
[meshBasket{:}] = ndgrid(gridInputs{:});



end

