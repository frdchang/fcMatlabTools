function [ outputs ] = applyFuncToCellRows(myFunc,myCellArray)
%APPLYFUNCTOCELLROWS applys myFunc(each cell row in myCellArray)

outputs = arrayfun(@(x) myFunc(myCellArray(x,:)),1:size(myCellArray,1),'un',0);



end

