function [groupedFiles,grouped] = groupByRegexp(fileList,grouping)
%GROUPBYREGEXP will find the groups defined by matched regexp of grouping.
%grouped is a index of the groups.  grouping should be unique per file.

matches = regexp(fileList,grouping,'match');

matches = [matches{:}];

grouped = findgroups(matches);

groupIds = unique(grouped);
numGroups = numel(groupIds);

groupedFiles = cell(numGroups,1);

for ii = 1:numGroups
   groupedFiles{ii} = fileList(grouped == groupIds(ii)); 
end

end

