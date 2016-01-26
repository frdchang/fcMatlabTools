function h = createMaxFigure()
%CREATEMAXFIGURE creates a maximum figure window given the users monitor
%resolution
%
% fchang@fas.harvard.edu

set(0,'units','pixels');  
BBoxScreen = get(0,'screensize');
width = BBoxScreen(3);
height = BBoxScreen(4);
h = figure('Position',[1,1,height,height]);

end

