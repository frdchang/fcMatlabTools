function [batchOutputs,runTimeBasket,counters] = sendChuncksByBatch(myFunc,listOflistOfArguments,varargin )
%SENDCHUNCKSBYBATCH will send work by chunks of listOflistOfArguments so as
%to limit batch overhead and master penalty.  the last chunk will simply be
% bigger 


%--parameters--------------------------------------------------------------
params.workersPerChunk = 12;
params.maxWorkers      = 256;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

% divide listOflistOfArguments into chunks
numChunks = floor(params.maxWorkers / (params.workersPerChunk + 1));
[M, N] = size(listOflistOfArguments); 
chunkedlistOflistOfArguments = mat2cell(listOflistOfArguments, diff(round(linspace(0, M, numChunks+1))), N);
chunkedlistOflistOfArguments = removeEmptyCells(chunkedlistOflistOfArguments);

chunkHandler = @(x) parForOnListOfArgs(myFunc,x{1});
% send it off to batches
[batchOutputs,runTimeBasket,counters] = sendFuncsByBatch(chunkHandler,chunkedlistOflistOfArguments,params.workersPerChunk,varargin);

% concate outputs
batchOutputs = vertcat(batchOutputs{:});
end

