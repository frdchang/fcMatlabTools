function fighandle = myshow(data,varargin)
%IMSHOW wraps matlab's imshow 

data = xyMaxProjND(data);
createMaxFigure();
fighandle =imshow(data,[],'Border','tight','InitialMagnification','fit');


end

