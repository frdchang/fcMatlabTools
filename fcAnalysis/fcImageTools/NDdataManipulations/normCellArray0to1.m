function [normedCellArray] = normCellArray0to1(cellArray)
%NORMCELLARRAY0TO1 will find the min and max of the entire cell array of
%numerics and convert to 0 to 1.  

myMin = ncellfun(@(x) min(x(x>-inf)),cellArray);
myMax = ncellfun(@(x) max(x(x<inf)),cellArray);
normedCellArray = cellfun(@(x,myMin,myMax) norm0to1(x,'userMin',myMin,'userMax',myMax),cellArray,myMin,myMax,'uni',0);
end

