function grabbed = grabFromListOfCells(listOfCells,grabber)
%GRABFROMLISTOFCELLS will apply to each cell the grabber which is passed
%into cellfun.  {'@(x) x{1}','@(x) x{2}'} will for each element of
%listOfCells, grab the first elmenet, and from that grab the second
%element.  note this function uses eval.

for i = 1:numel(grabber)
   listOfCells = eval(['cellfunNonUniformOutput(' grabber{i} ',listOfCells);']);
end

grabbed = listOfCells;


