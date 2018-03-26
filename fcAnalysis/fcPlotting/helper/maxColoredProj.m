function [ coloredProj ] = maxColoredProj(data,dim)
%MAXCOLOREDPROJ creates and rgb colormapped in the dimension specified
myCmapFunc = @hsv;

data = norm0to1(data);
[maxproj,idx] = max(data,[],dim);

zcolormap = ind2rgb(idx,myCmapFunc(size(data,dim)));
hsvColormap = rgb2hsv(zcolormap);
hsvColormap(:,:,3) = maxproj;
coloredProj = hsv2rgb(hsvColormap);
coloredProj = uint8(255*coloredProj);
end

