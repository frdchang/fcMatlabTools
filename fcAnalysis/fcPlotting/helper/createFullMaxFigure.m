function h = createFullMaxFigure(varargin)
%CREATEMAXFIGURE creates a maximum figure window given the users monitor
%resolution
%
% fchang@fas.harvard.edu
shrinkFactor = 1;
set(0,'units','pixels');
BBoxScreen = get(0,'screensize');
width = BBoxScreen(3);
height = BBoxScreen(4);

if isempty(varargin)
    h = figure('Position',round([width*(1-shrinkFactor),height*(1-shrinkFactor),width*shrinkFactor,height*shrinkFactor]));
else
    h = figure('Position',round([width*(1-shrinkFactor),height*(1-shrinkFactor),width*shrinkFactor,height*shrinkFactor]),'Name',varargin{1},'NumberTitle','off');
    
end
