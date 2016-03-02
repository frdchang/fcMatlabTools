function h = plotSurf(surfData,projData,varargin)
%PLOTSURF plots multiple color surfaces
% surfData = {surfData1,surfData2,surfData3}
% projData = {projData1,projData1,projData3}
% colors used will be {red,green,blue}
%
imgzposition = -10000;
numDatas = max(numel(surfData),numel(projData));

if numDatas > 3
    error('number of datasets exceeds 3');
end

% generate grid
[x,y] = meshgrid(1:size(surfData{1},2),1:size(surfData{1},1));
% get the corners of the domain in which the data occurs.
min_x = min(min(x));
min_y = min(min(y));
max_x = max(max(x));
max_y = max(max(y));
% plot the projected datas
h = figure('Renderer','opengl');
grayMap = gray(256);
curProjDataHolder = zeros(size(projData{1},1),size(projData{1},2),3);
for i = 1:numDatas
    currMap = zeros(size(grayMap));
    currMap(:,i) = grayMap(:,1);
    curProjData = round((norm0to1(projData{i}))*256);
    curProjDataHolder = curProjDataHolder + ind2rgb(curProjData,currMap);
end
alphas = norm0to1(maxintensityproj(curProjDataHolder,3));
surf(x,y,imgzposition*ones(size(x)),curProjDataHolder,'edgecolor','none');
hold on;

%plot the surface datas
faceColors = {'red','green','blue'};
for i = 1:numDatas
    currMap = zeros(size(grayMap));
    currMap(:,i) = grayMap(:,1);
    curProjData = round(norm0to1(surfData{i})*256);
    curProjData = ind2rgb(curProjData,currMap);
    alphas = norm0to1(surfData{i});
    alphas(alphas<0.1) = 0;
    alphas(alphas>0.1) = 1;
    surf(x,y,2000*norm0to1(surfData{i}),'FaceColor',faceColors{i},'AlphaData',alphas,'AlphaDataMapping','none','FaceAlpha','flat','EdgeAlpha','flat');hold on;
end

% 
end

