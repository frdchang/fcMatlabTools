function fighandle = myshow(data,varargin)
%IMSHOW wraps matlab's imshow 
if iscell(data)
   data = flattenCellArray(data);
   data = cat(2,data{:}); 
end
data = xyMaxProjND(data);
createMaxFigure();
fighandle =imshow(data,[],'Border','tight','InitialMagnification','fit');


end

