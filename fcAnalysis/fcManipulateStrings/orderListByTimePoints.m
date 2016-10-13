function orderedByTime = orderListByTimePoints(fileList)
%ORDERLISTBYTIMEPOINTS will take the cell list of files and order them by
%time, _t[0-9]+

orderedByTime = getOrderedListFromMatch(fileList,'[0-9]+','ascend');

orderedByTime = orderedByTime{1}.subMatch;
end

