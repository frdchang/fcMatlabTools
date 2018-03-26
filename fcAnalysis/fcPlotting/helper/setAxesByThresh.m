function [  ] = setAxesByThresh( h,sigmas)
%SETAXESBYTHRESH will set the x axis by cdf of the histgram in h and by
%thresh

 currAxis = axis;
 
 
 yVals =  h.BinCounts;
 xVals = h.BinEdges;
 
 pdf = yVals / sum(yVals);
 domain = xVals + h.BinWidth;
 domain = domain(1:end-1);
 xMean =sum( pdf.* domain);
 xSTD = sum(pdf.*(domain.^2)) - xMean.^2;
 xSTD = sqrt(xSTD);
 axis([xMean-sigmas*xSTD, xMean + sigmas*xSTD 0 currAxis(4)]);


end

