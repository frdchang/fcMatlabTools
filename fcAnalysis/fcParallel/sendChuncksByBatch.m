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
[numEl, N] = size(listOflistOfArguments);

if numEl > numChunks
    divider = diff(round(linspace(0, numEl, numChunks+1)));
else
    divider = numEl;
end

chunkedlistOflistOfArguments = mat2cell(listOflistOfArguments,divider, N);
chunkedlistOflistOfArguments = removeEmptyCells(chunkedlistOflistOfArguments);



numWorkers = min(params.workersPerChunk,numEl);
chunkHandler = @(x) parForOnListOfArgs(myFunc,x);
% send it off to batches
[batchOutputs,runTimeBasket,counters] = sendFuncsByBatch(chunkHandler,chunkedlistOflistOfArguments,numWorkers,varargin);

% concate outputs
batchOutputs = vertcat(batchOutputs{:});
batchOutputs = vertcat(batchOutputs{:});
end

