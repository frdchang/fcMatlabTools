function [rgbLabel,rgbLabelandText] = plotLabels(dataND,L,varargin)
%PLOTLABELS will provide rgbLabeling of ndData which will be shown by xy
% maximum intensity projection

%--parameters--------------------------------------------------------------
params.showTextLabels    = true;
params.showPlot          = true;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

dataND = xyMaxProjND(dataND);
L = xyMaxProjND(L);
alpha = 0.3;
rgbLabel = uint8(255.*norm0to1(dataND));
% cmap = distinguishable_colors(max(L(:)),[1 1 1; 0 0 0]);
cmap = linspecer(double(max(L(:))));
Lrgb = label2rgb(double(L),cmap,'k','shuffle');
hitIndex = find(bwperim(L>0)>0);
insideIndex = find(L>0);
R = Lrgb(:,:,1);
G = Lrgb(:,:,2);
B = Lrgb(:,:,3);
RI = rgbLabel;
GI = rgbLabel;
BI = rgbLabel;
RI(insideIndex) = alpha*R(insideIndex) + (1-alpha)*rgbLabel(insideIndex);
GI(insideIndex) = alpha*G(insideIndex) + (1-alpha)*rgbLabel(insideIndex);
BI(insideIndex) = alpha*B(insideIndex) + (1-alpha)*rgbLabel(insideIndex);

RI(hitIndex) = R(hitIndex);
GI(hitIndex) = G(hitIndex);
BI(hitIndex) = B(hitIndex);
rgbLabel = cat(3,RI,GI,BI);

if params.showTextLabels
    stats = regionprops(L);
    % generate text mask
    %     h = figure('Visible','off');
    %     set(h, 'PaperPositionMode','auto');
    %     imshow(rgbLabel);
    textImg = labelBWstack(dataND,stats);
    textImg = cat(3,textImg,textImg,textImg);
    rgbLabelandText = rgbLabel;
    rgbLabelandText(textImg>0) = 255;
    %     rgbLabelandText = hardcopy(h, '-dzbuffer', '-r0');
    if params.showPlot
        imshow(rgbLabelandText)
    end
else
    if params.showPlot
        imshow(rgbLabel)
    end
end



end

