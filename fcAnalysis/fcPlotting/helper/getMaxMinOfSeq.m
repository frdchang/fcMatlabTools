function itsExtremas = getMaxMinOfSeq(listOfFiles)
%GETMAXMINOFSEQ will load the data from listOfFiles and return the maximum
%and minimum values.

itsMax = -inf;
itsMin = inf;

for ii = 1:numel(listOfFiles)
   currStack = importStack(listOfFiles{ii});
   subSet = cellfunNonUniformOutput(@(currStack) currStack(currStack > -inf & currStack < inf),currStack);
   itsMax = max(itsMax,max(cellfun(@max,subSet)));
   itsMin = min(itsMin,min(cellfun(@min,subSet)));
end

itsExtremas.max = itsMax;
itsExtremas.min = itsMin;
end

