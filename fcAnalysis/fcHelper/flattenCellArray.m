function cellarray = flattenCellArray(cellarray)
%FLATTENCELLARRAY will flatten a complicated cell array
%
% fchang@fas.harvard.edu
% if iscell(cellarray)
% cellarray = {cellarray{:}};
% else
%    cellarray = {cellarray}; 
% end
while iscell(cellarray)
    if (size(cellarray,1) == 1 || size(cellarray,2)==1) && ~any(cellfun(@iscell,cellarray))
       % flattened if the first dimension is 1
       break; 
    end
    cellarray=cellfun(@(x) x(:).',cellarray,'uni',false);
    cellarray=[cellarray{:}];
end


end

