function groupedTimeLapses = groupByTimeLapses(fileList)
%GROUPBYTIMELAPSES will take the file list and group by timelapse defined
%by '_t[0-9]+'.  the subgroups will have disagreement characters that will
%be ordered by numerical then lexographical.

groups = getOrderedListFromMatch(fileList,'_t[0-9]+','ascend');

timeLapseNames = cellfunNonUniformOutput(@(x) x.nonVaryingPart,groups);

[~,indices] = sort_nat(timeLapseNames,'ascend');
groupedTimeLapses = cellfunNonUniformOutput(@(x) x.subMatch,groups(indices));
end
