function [] = imtool3DMax(data)
%IMTOOL3DMAX Summary of this function goes here
%   Detailed explanation goes here

h = createMaxFigure();
imtool3D(data,[0,0,1,1],h);

end

