%% check dft alignment 
qpmImages = getAllFiles('/Users/fchang/Desktop/qpmData','tif');
qpmImages = getOrderedListFromMatch(qpmImages,'[0-9]+','ascend');
qpmImages = qpmImages{1}.subMatch;
[xyAlignments] = getXYstageAlignment(qpmImages,'saveToLocation','~/Desktop/aligned');
