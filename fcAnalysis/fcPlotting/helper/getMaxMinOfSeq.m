function itsExtremas = getMaxMinOfSeq(listOfFiles)
%GETMAXMINOFSEQ will load the data from listOfFiles and return the maximum
%and minimum values.

itsMax = -inf;
itsMin = inf;

for ii = 1:numel(listOfFiles)
   currStack = importStack(listOfFiles{ii});
   subSet = currStack(currStack > -inf & currStack < inf);
   itsMax = max(itsMax,max(subSet));
   itsMin = min(itsMin,min(subSet));
end

itsExtremas.max = itsMax;
itsExtremas.min = itsMin;
end

