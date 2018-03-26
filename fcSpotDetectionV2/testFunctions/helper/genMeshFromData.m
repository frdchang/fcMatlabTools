function meshBasket = genMeshFromData(data,varargin)
%GENMESHFROMDATA will gen mesh from data
% you can up sample (which is downsample for use) by varargin

meshBasket = cell(ndims(data),1);
if isempty(varargin)
    gridInputs = cellfunNonUniformOutput(@(x) [1:x],num2cell(size(data)));

else
    gridInputs = cellfunNonUniformOutput(@(x,y) linspace(1,x/y,x),num2cell(size(data)),num2cell(varargin{1}));

end
[meshBasket{:}] = ndgrid(gridInputs{:});



end

