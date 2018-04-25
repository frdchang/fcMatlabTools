function [normedCellArray] = normCellArraytoUINT8(cellArray)
%NORMCELLARRAY0TO1 will find the min and max of the entire cell array of
%numerics and convert to 0 to 255 uint8.  
normedCellArray = normCellArray0to1(cellArray);
normedCellArray = cellfun(@(x) uint8(x*255),normedCellArray,'uni',0);
end

