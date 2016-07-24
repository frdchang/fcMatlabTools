function [rgbLabel,rgbLabelandText] = plotLabels(image,stats,L)
%PLOTLABELS Summary of this function goes here
%   Detailed explanation goes here
% varargout{1} = rgbLabel (if stats isempty)
% varargout{2} = rgbLbaelandText (if stats is provided)

alpha = 0.3;
rgbLabel = uint8(255.*norm0to1(image));
cmap = distinguishable_colors(max(L(:)),[1 1 1; 0 0 0]);
Lrgb = label2rgb(double(L),cmap,'k');
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
varargout{1} = rgbLabel;

if isempty(stats)
    
else
    % generate text mask
%     h = figure('Visible','off');
%     set(h, 'PaperPositionMode','auto');
%     imshow(rgbLabel);
    textImg = labelBWstack(image,stats);
    textImg = cat(3,textImg,textImg,textImg);
    rgbLabelandText = rgbLabel;
    rgbLabelandText(textImg>0) = 255;
%     rgbLabelandText = hardcopy(h, '-dzbuffer', '-r0');
    varargout{2} = rgbLabelandText;
end


end

