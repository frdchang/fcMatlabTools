function itsExtremas = getMaxMinOfSeq(listOfFiles)
%GETMAXMINOFSEQ will load the data from listOfFiles and return the maximum
%and minimum values.

itsMax = -inf;
itsMin = inf;

for ii = 1:numel(listOfFiles)
   currStack = importStack(listOfFiles{ii});
   itsMax = max(itsMax,max(currStack(currStack>-inf)));
   itsMin = min(itsMin,min(currStack(currStack>-inf)));
end

itsExtremas.max = itsMax;
itsExtremas.min = itsMin;
end

