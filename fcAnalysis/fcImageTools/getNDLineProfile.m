function profileBasket = getNDLineProfile(ndData,coorList,varargin)
%NDPROFILE gets the line segment profile of ndData, given ND coorList
%   {coor1, coor2, ...}. 
%   outputs a profileBasket of:
%   {linesegment(coor1 to coor2), linesegment(coor2 to coor3),...
%   note: currently uses indexing coordinates of ndData

%--parameters--------------------------------------------------------------
params.interpBy     = [];  % interpn options {'nearest','linear','spline','cubic'}
params.N            = [];  % if you want to specify the number of samples
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

numCoors = numel(coorList);
profileBasket = cell(numCoors-1,1);
for i = 1:(numCoors-1)
    startLine = coorList{i};
    endLine   = coorList{i+1};
    % generate coordinates for line segement i
    argBasket = cell(numel(startLine),1);
    for j = 1:numel(argBasket)
        if isempty(params.N)
            argBasket{j} = startLine(j):endLine(j);
        else
            argBasket{j} = linspace(startLine(j),endLine(j),params.N);
        end
    end
    profileBasket{i} = interpn(ndData,argBasket{:});
    profileBasket{i} = profileBasket{i}(:);
end



end

