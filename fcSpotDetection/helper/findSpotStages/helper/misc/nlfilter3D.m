function b = nlfilter3D(cellDatas,nhood,myFunc,params,padval)
%NLFILTER3D is a modification of nlfilter but allows 3d data to be
% processed by sliding box defined by nhood.
%
% cellDatas:        cell array of the datas to be passed {data1,data2,..}
%                   assumes: size(data1) = size(data2) = ....
% nhood:            size of the neighborhood to be slid
% myFunc            function to be applied on the nhood of cellDatas
% params:           function parameters appended after datas
% padval:           value of the padding
% b:                a cell array holding the outputs of myFunc applied to
%                   patches
%
%
% e.g. b(nhood_i) = fun(data1(nhood_i),data2(nhood_i),...,params{:});
%
% [notes] - i usually pad by -inf so the function recieving the patch knows
%           what parts of the data was padded.
%
% fchang@fas.harvard.edu

if isempty(params)
    params = {};
end

% find size of the dataset
[ma,na,oa] = size(cellDatas{1});
% pad the datasets to accound for nhood bleeding at the edge
paddedCellDatas = cell(numel(cellDatas),1);
for i = 1:numel(paddedCellDatas)
    % create padval padded versions of cellData_i
    paddedCellDatas{i} = repmat(feval(class(cellDatas{1}), padval), size(cellDatas{1})+nhood-1);
    % fill in the center of padded versions with cellData_i
    paddedCellDatas{i}(floor((nhood(1)-1)/2)+(1:ma),floor((nhood(2)-1)/2)+(1:na),floor((nhood(3)-1)/2)+(1:oa)) = cellDatas{i};
end

% neighborhood indices selector
rows = 0:(nhood(1)-1);
cols = 0:(nhood(2)-1);
zs   = 0:(nhood(3)-1);

% create b with the cells corresponding to the number of outputs of myFunc
x = cell(numel(paddedCellDatas),1);
for l = 1:numel(paddedCellDatas)
    x{l} = paddedCellDatas{l}(1+rows,1+cols,1+zs);
end
numOutput = nargout(myFunc);
b = cell(numOutput,1);
for i = 1:numOutput
    b{i} = zeros(size(cellDatas{1}));
end
outputCapture = cell(numOutput,1);
% Apply fun to each neighborhood of cellDatas
for i=1:ma
    x = cell(numel(paddedCellDatas),1); 
    for j=1:na
        for k = 1:oa
            for l = 1:numel(paddedCellDatas)
                x{l} = paddedCellDatas{l}(i+rows,j+cols,k+zs);
            end
            display([num2str(i) ',' num2str(j) ',' num2str(k)]);
            [outputCapture{:}] = feval(myFunc,x{:},params{:});
            for m = 1:numOutput
                b{m}(i,j,k) = outputCapture{m};
            end
        end
    end
end



