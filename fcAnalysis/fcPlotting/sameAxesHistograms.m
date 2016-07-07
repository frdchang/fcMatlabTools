function [] = sameAxesHistograms(cellOfHistogramHandles)
%SAMEAXESHISTOGRAMS will take a cell list of histogram handles and convert
%all of them to have the same widest histogram of the cohort.
lowerLimit = inf;
upperLimit = -inf;
for i = 1:numel(cellOfHistogramHandles)
    currHist = cellOfHistogramHandles{1};
    if currHist.BinLimits(1) < lowerLimit
        lowerLimit = currHist.BinLimits(1);
    end
    
    if currHist.BinLimits(2) > upperLimit
        upperLimit = currHist.BinLimits(2);
    end
end

binWidths = zeros(numel(cellOfHistogramHandles));

for i = 1:numel(cellOfHistogramHandles)
   binWidths = cellOfHistogramHandles{i}.BinWidth; 
end

binWidths = mode(binWidths);

for i = 1:numel(cellOfHistogramHandles)
   cellOfHistogramHandles{i}.BinLimits = [lowerLimit upperLimit];
end


end

