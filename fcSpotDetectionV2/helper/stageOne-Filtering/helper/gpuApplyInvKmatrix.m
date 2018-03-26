function cellDataIn = gpuApplyInvKmatrix(kMatrix,cellDataIn)
%GPUAPPLYINVKMATRIX will take kmatrix and solve the system given varargin
%datasets.  should be gpu friendly.

sizeADataset    = size(cellDataIn{1});

cellDataIn = cellfunNonUniformOutput(@(x) x(:),cellDataIn);
cellDataIn = [cellDataIn{:}]';
cellDataIn = kMatrix \ cellDataIn;
cellDataIn = num2cell(cellDataIn,2);
cellDataIn = cellfunNonUniformOutput(@(x) reshape(x,sizeADataset),cellDataIn);

 
