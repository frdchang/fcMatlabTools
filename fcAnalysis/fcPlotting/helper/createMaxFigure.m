function h = createMaxFigure()
%CREATEMAXFIGURE creates a maximum figure window given the users monitor
%resolution
%
% fchang@fas.harvard.edu
shrinkFactor = 0.95;
set(0,'units','pixels');  
BBoxScreen = get(0,'screensize');
width = BBoxScreen(3);
height = BBoxScreen(4);
h = figure('Position',round([height*(1-shrinkFactor),height*(1-shrinkFactor),height*shrinkFactor,height*shrinkFactor]));

end

