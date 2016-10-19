function textImg = labelBWstack(img,stats)
%LABELBWSTACK Summary of this function goes here
%   Detailed explanation goes here

numCells = numel(stats);
textImg = zeros(size(img));
for i = 1:numCells
    if ~any(isnan(stats(i).Centroid))
     textCoor = ceil(stats(i).Centroid);
     text = imresize(~norm0to1(text2im(num2str(i))),0.5,'nearest');
     temp = implace(textImg,text,textCoor(2),textCoor(1));
     textImg = textImg + temp;
    end
end
textImg = textImg > 0;
end

