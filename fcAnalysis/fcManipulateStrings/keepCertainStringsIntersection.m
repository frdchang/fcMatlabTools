function fileList = keepCertainStringsIntersection(fileList,keepFile)
%REMOVECERTAINFILES takes fileList and returns a new fileList with
%removeFile removed from the list.
% keepFile can be a cell array of regexp patterns and this function will
% take the intersection of them


if isempty(fileList)
    fileList = [];
    return;
end

if ~iscell(keepFile)
    dsCheck = regexp(fileList,keepFile);
    dsCheck = cellfun('isempty',dsCheck);
    fileList(dsCheck) = [];  
else
    for i = 1:numel(keepFile)
        currKeeper = keepFile{i};
        dsCheck = regexp(fileList,currKeeper);
        dsCheck = cellfun('isempty',dsCheck);
        fileList(dsCheck) = [];
    end
end

fileList = fileList(~cellfun('isempty',fileList));



end

