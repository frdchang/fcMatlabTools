function [  ] = visualizeTraj( peaks )
%VISUALIZETRAJ Summary of this function goes here
%   Detailed explanation goes here
nframe = numel(peaks);
C = peaks{1}(:,1);
R = peaks{1}(:,2);
X = [[C'-2; C'+2], [C'; C']];
Y = [[R'; R'], [R'-2; R'+2]];
hand = line(X,Y);
set(hand(:),'Color',[1 0 0]);
for iframe=2:nframe
    oldind = find(peaks{iframe-1}(:,6)>0);
    curind = peaks{iframe-1}(oldind,6);
    X = [peaks{iframe-1}(oldind,1), peaks{iframe}(curind,1)];
    Y = [peaks{iframe-1}(oldind,2), peaks{iframe}(curind,2)];
    hand = line(X',Y');
    set(hand(:),'Color',[1 0 0]);
    set(hand(:),'LineWidth',[1.0]);
end
hold off


end

