function [fig] = plot3Dstack(varargin)
%plot3DStack takes the 3D volume stack and plots a max projection from each
%cardinal direction.  Scale bars are calculated from the magnficiation
%{mag} and camera pixel size {pixelSize} information for X,Y pixel.
%the relative z pixel w.r.t. the xy pixel is calculated from the zStep to
%pixelSize ratio
%
% plot3DStack2(stack,250,13,0.2,'uM');
%stack, mag, pixelSize, zStep, units,varargin
%    __y__   __z__
%  x|     | |     |
%   |     | |     |
%    _____
%  z|     |
%   |     |
%

% parameters
markerParam = {'or','LineWidth',3,'MarkerSize',15};
markerParamW = {'ow','LineWidth',1,'MarkerSize',10};
nucleiParam = {'-sr'};
volumeParam = {'FaceColor',[1,0,0],'EdgeAlpha',0.1,'FaceAlpha',0.5};
volMarkerParam = {80,'fill','ko','MarkerEdgeColor',[0,0,0],'MarkerFaceColor',[0,0,0]};
edgeParams = {'-b','LineWidth',1.5};
pairWiseParam = {'-r','LineWidth',1.5};
projParam  = {'Color',[0.3 0.3 0.3]};
segmentationParams = {'--w','LineWidth',1.5};
rgbTol = 0.02;


p = inputParser;
p.addRequired('stack',@(x) true);
p.addParamValue('mag',60,@isscalar);
p.addParamValue('pixelSize',6.5,@isscalar);
p.addParamValue('zStep',0.280,@isscalar);
p.addParamValue('units','uM',@isstr);
p.addParamValue('scalebar',[],@isscalar);
p.addParamValue('cRange',[],@(x) length(x)==2);
p.addParamValue('myCmap',[],@(x) true);
p.addParamValue('cBar',0,@isscalar);
p.addParamValue('text',[],@(x) true);
p.addParamValue('clustCent',[],@(x) true);
p.addParamValue('nucVol',[],@(x) true);
p.addParamValue('enhanced',[],@(x) true);
p.addParamValue('nucDists',[],@(x) true);
p.addParamValue('stats',[],@(x) true);
p.addParamValue('stackRed',[],@(x) true);
p.addParamValue('stackBlue',[],@(x) true);
p.addParamValue('segmentation',[],@(x) true);
p.addParamValue('xyMask',[],@(x) true);
p.addParamValue('snake',[],@(x) true);
p.addParamValue('toDisk',false,@(x) true);
p.addParamValue('forPoster',false,@(x)true);
p.addParamValue('MLEtraj',[],@(x)true);
p.addParamValue('colorCodeProj',false,@(x) true);
p.addParamValue('spotParams',[],@(x) true);
p.addParamValue('projectionFunc',@maxintensityproj,@(x) true);
p.addParamValue('keepFigure',[],@(x) true);

p.parse(varargin{:});

input       = p.Results;

stack       = input.stack;
mag         = input.mag;
pixelSize   = input.pixelSize;
zStep       = input.zStep;
units       = input.units;
scalebar    = input.scalebar;
clustCent   = input.clustCent;
nucVol      = input.nucVol;
enhanced    = input.enhanced;
nucDists    = input.nucDists;
stats       = input.stats;
stackRed    = input.stackRed;
stackBlue   = input.stackBlue;
segmentation= input.segmentation;
xyMask      = input.xyMask;
toDisk      = input.toDisk;
snake       = input.snake;
forPoster   = input.forPoster;
MLEtraj     = input.MLEtraj;
colorCodeProj = input.colorCodeProj;
spotParams  = input.spotParams;
projectionFunc = input.projectionFunc;
keepFigure = input.keepFigure;

if forPoster
    border = 0.02;
    nTicks = 20;
    bkgColor = [1,1,1];
    xStep = pixelSize / mag;
    relZSize = zStep / xStep;
else
    border = 0.035;
    nTicks = 20;
    bkgColor = [0.6,0.6,0.6];
    xStep = pixelSize / mag;
    relZSize = zStep / xStep;
end
stack = gather(stack);
stack = double(stack);
[xL,yL,zL] = size(stack);

% In order to arrange the subplots of the three max projections, I need to
% calculate the relative sizing of each frames.
% in the x direction

relXDirX = xL / (xL + zL*relZSize);
relXDirZ = 1 - relXDirX;
% in the y direction
relYDirY = yL / (yL + zL*relZSize);
relYDirZ = 1 - relYDirY;

% define image patch proportional to xL vs yL
alphaCorr = (relXDirX / relYDirY)*(yL/xL);
if xL > yL
    relYDirY = relYDirY * alphaCorr;
    relYDirZ = relYDirZ * alphaCorr;
else
    % yL >= xL
    relXDirX = relXDirX * (1/alphaCorr);
    relXDirZ = relXDirZ * (1/alphaCorr);
end

% now calculate the border compensation
relXDirX = (1-4*border)*relXDirX;
relXDirZ = (1-4*border)*relXDirZ;
relYDirY = (1-4*border)*relYDirY;
relYDirZ = (1-4*border)*relYDirZ;

% define figure window with appropriate proportions

if keepFigure
    
else
    if ~toDisk
        fig = figure('Position', [10, 10, 1400, 1400]);
    else
        fig = figure('Position', [10, 10, 1400, 1400],'Visible','off');
    end
end


if forPoster
    set(gcf,'color','w');
else
    
end


% grey background
if forPoster
    
else
    whitebg(bkgColor);
end

if ~isempty(input.myCmap)
    myCmap = input.myCmap;
else
    %load cmap_fire;
    %myCmap = cmap_fire;
    myCmap = gray;
end


if ~isempty(clustCent)
    myCmap = gray;
end

if ~isempty(nucVol) || ~isempty(xyMask)
    myCmap = gray;
end


if ~isempty(input.text)
    input.text = strrep(input.text,'_','\_');
    
end
% calculate tick Ranges
xTicks = nTicks*relXDirX;
yTicks = nTicks*relYDirY;
zTicks = nTicks*relXDirZ*2;

% i want the ticks to be nice like {1,10,20,...}
xTicks = round((xL/xTicks) / 10)*10;
yTicks = round((yL/yTicks) / 10)*10;
zTicks = round((zL/zTicks) / 10)*10;

if xTicks == 0
    xTicks = 1;
end

if yTicks == 0
    yTicks = 1;
end

if zTicks == 0
    zTicks = 1;
end


if xTicks > yTicks
    xRange = xTicks:xTicks:floor(xL/xTicks)*xTicks;
    yRange = xTicks:xTicks:floor(yL/xTicks)*xTicks;
else
    xRange = yTicks:yTicks:floor(xL/yTicks)*yTicks;
    yRange = yTicks:yTicks:floor(yL/yTicks)*yTicks;
end
zRange = zTicks:zTicks:floor(zL/zTicks)*zTicks;

if ~isempty(clustCent)
    %     pairWiseLines = returnPairWiseDists(clustCent)';
end

minVal = min(stack(:));
maxVal = max(stack(:));

% now subplot each frame subplot('Position',[left bottom width height])
%% PLOT XY-----------------------------------------------------------------
subplot('Position',[2*border,1 - (2*border + relXDirX),relYDirY,relXDirX]);

if isempty(stackRed) && isempty(stackBlue)
    imagesc(projectionFunc(stack, 3));
    colormap(myCmap);
    caxis([minVal,maxVal]);
else
    rgbStack(xL,yL,3) = 0;
    markerParam = markerParamW;
    if isempty(stackBlue)
        rgbStack(:,:,1) = norm0to1(maxintensityproj(stackRed,3));
        rgbStack(:,:,2) = norm0to1(maxintensityproj(stack,3));
        rgbStack(:,:,3) = 0;
        image(rgbStack);
    elseif isempty(stackRed)
        rgbStack(:,:,1) = 0;
        rgbStack(:,:,2) = norm0to1(maxintensityproj(stack,3));
        rgbStack(:,:,3) = norm0to1(maxintensityproj(stackBlue,3));
        image(rgbStack);
    else
        rgbStack(:,:,1) = norm0to1(maxintensityproj(stackRed,3));
        rgbStack(:,:,2) = norm0to1(maxintensityproj(stack,3));
        rgbStack(:,:,3) = norm0to1(maxintensityproj(stackBlue,3));
        image(rgbStack);
    end
end


if ~isempty(input.cRange)
    caxis(input.cRange);
end

ylabel('x (pixels)');
xlabel('y (pixels)');
set(gca,'Xtick',yRange);
set(gca,'Ytick',xRange);
set(gca,'XAxisLocation','top');
box off;

if forPoster
    set(gca,'fontsize',10,'Xcolor','k','Ycolor','k');
    set(get(gca,'Title'),'Color','k');
else
    set(gca,'fontsize',10,'Xcolor','w','Ycolor','w');
    set(get(gca,'Title'),'Color','w');
end

% if ~isempty(nucDists)
%     hold on;
%     for i = 1:size(nucDists,2)
%         plot([clustCent(2,i),nucDists(2,i)],...
%             [clustCent(1,i),nucDists(1,i)],edgeParams{:});
%     end
% end

if ~isempty(clustCent)
    hold on;plot(clustCent(2,:),clustCent(1,:),markerParam{:});
end

if ~isempty(nucVol)
    hold on;
    %     nucVolxy = maxintensityproj(nucVol,3);
    %     nucVolxy = maskToCoors(nucVolxy>0);
    %     K = convhull(nucVolxy(:,1),nucVolxy(:,2));
    %     plot(nucVolxy(K,2),nucVolxy(K,1),nucleiParam{:});
    traceBW(nucVol,3);
end

if ~isempty(xyMask)
    traceBW2D(xyMask);
end

if ~isempty(stats)
    labelBWstack(stats);
end

if ~isempty(snake)
    hold on;
    if iscell(snake)
        for i = 1:numel(snake)
            currSnake = snake{i};
            plot(currSnake(:,2),currSnake(:,1),'.r','MarkerSize',6);
        end
    else
        plot(snake(:,2),snake(:,1),'.r','MarkerSize',6);
    end
end

if ~isempty(MLEtraj)
    
    xyzs = cellfun(@(x) x(1:3),MLEtraj,'UniformOutput',false);
    xyzs = cellfun(@(x) x',xyzs,'UniformOutput',false);
    xyzs = cell2mat(xyzs);
    c = 1:size(xyzs,2);
    x = xyzs(1,:);
    y = xyzs(2,:);
    z = xyzs(3,:)*0;
    surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], ...
        [c(:), c(:)], 'EdgeColor','flat', 'FaceColor','none');
    %     colormap(gca,'default');
    hold on;
    plot(x(1),y(1),'r.','MarkerSize',10);
    plot(x(end),y(end),'g.','MarkerSize',10);
end

if ~isempty(spotParams)
    hold on;
    numSpots = numel(spotParams);
    colorSpots =  cool(numSpots);
    logLikeHoodsRatio = [spotParams.LLRatio];
    [logSorted,sortedI] = sort(logLikeHoodsRatio);
    for ii = 1:numSpots
        thetaMLE = cell2mat(spotParams(sortedI(ii)).thetaMLE);
        coordinate = thetaMLE(1:3);
        hold on; plot(coordinate(1),coordinate(2), markerParam{:},'markerEdgeColor',colorSpots(ii,:));
    end
end
%% PLOT XZ-----------------------------------------------------------------
subplot('Position',[3*border+relYDirY,1 - (2*border + relXDirX),relYDirZ,relXDirX]);
if isempty(stackRed) && isempty(stackBlue)
    imagesc(projectionFunc(stack, 2));
    colormap(myCmap);
    if ~isempty(input.cRange)
        caxis(input.cRange);
    else
        
        caxis([minVal,maxVal]);
    end
else
    clear rgbStack;
    rgbStack(xL,zL,3) = 0;
    if isempty(stackBlue)
        rgbStack(:,:,1) = norm0to1(maxintensityproj(stackRed,2));
        rgbStack(:,:,2) = norm0to1(maxintensityproj(stack,2));
        rgbStack(:,:,3) = 0;
        image(rgbStack);
    elseif isempty(stackRed)
        rgbStack(:,:,1) = 0;
        rgbStack(:,:,2) = norm0to1(maxintensityproj(stack,2));
        rgbStack(:,:,3) = norm0to1(maxintensityproj(stackBlue,2));
        image(rgbStack);
    else
        rgbStack(:,:,1) = norm0to1(maxintensityproj(stackRed,2));
        rgbStack(:,:,2) = norm0to1(maxintensityproj(stack,2));
        rgbStack(:,:,3) = norm0to1(maxintensityproj(stackBlue,2));
        image(rgbStack);
    end
end

if ~isempty(scalebar)
    xScale = scalebar / xStep;
    zScale = scalebar / zStep;
    hold on; plot([1,1],[xL-1,xL-(xScale)-1],'w','LineWidth',4);
    hold on; plot([1,zScale+1],[xL-1,xL-1],'w','LineWidth',4);
    txt = text(zL*2*zStep/xStep*border,xL*(1-2*border)-2*xStep/zStep,[num2str(scalebar) units]);
    set(txt,'fontsize',14,'Color','w','VerticalAlignment','middle');
end

set(gca,'YTickLabel','');
set(gca,'Xtick',zRange);
set(gca,'Ytick',yRange);
xlabel('z (steps)');
set(gca,'XAxisLocation','top');
set(gca,'YAxisLocation','right');
box off;
if forPoster
    set(gca,'fontsize',10,'Xcolor','k','Ycolor','k');
    set(get(gca,'Title'),'Color','k');
else
    set(gca,'fontsize',10,'Xcolor','w','Ycolor','w');
    set(get(gca,'Title'),'Color','w');
end

if ~isempty(clustCent)
    hold on;plot(clustCent(3,:),clustCent(1,:),markerParam{:});
end

if ~isempty(nucVol)
    %     hold on;
    %     nucVolxy = maxintensityproj(nucVol,2);
    %     nucVolxy = maskToCoors(nucVolxy>0);
    %     K = convhull(nucVolxy(:,1),nucVolxy(:,2));
    %     plot(nucVolxy(K,2),nucVolxy(K,1),nucleiParam{:});
    traceBW(nucVol,2);
end

if ~isempty(segmentation)
    traceBW(segmentation,2,segmentationParams{:});
end

if ~isempty(MLEtraj)
    
    xyzs = cellfun(@(x) x(1:3),MLEtraj,'UniformOutput',false);
    xyzs = cellfun(@(x) x',xyzs,'UniformOutput',false);
    xyzs = cell2mat(xyzs);
    c = 1:size(xyzs,2);
    x = xyzs(1,:);
    y = xyzs(2,:)*0;
    z = xyzs(3,:);
    surface([z(:), z(:)], [x(:), x(:)], [y(:), y(:)], ...
        [c(:), c(:)], 'EdgeColor','flat', 'FaceColor','none');
    %     colormap(gca,'default');
    hold on;
    plot(z(1),x(1),'r.','MarkerSize',10);
    plot(z(end),x(end),'g.','MarkerSize',10);
end


if ~isempty(spotParams)
    hold on;
    numSpots = numel(spotParams);
    colorSpots =  cool(numSpots);
    logLikeHoodsRatio = [spotParams.logLike];
    [logSorted,sortedI] = sort(logLikeHoodsRatio);
    for ii = 1:numSpots
        thetaMLE = cell2mat(spotParams(sortedI(ii)).thetaMLE);
        coordinate = thetaMLE(1:3);
        hold on; plot(coordinate(3),coordinate(2), markerParam{:},'markerEdgeColor',colorSpots(ii,:));
    end
end


%% PLOT ZY-----------------------------------------------------------------
subplot('Position',[2*border,1 - (3*border + relXDirZ + relXDirX),relYDirY,relXDirZ]);
if isempty(stackRed) && isempty(stackBlue)
    imagesc(projectionFunc(stack, 1)');
    colormap(myCmap);
    if ~isempty(input.cRange)
        caxis(input.cRange);
    else
        caxis([minVal,maxVal]);
    end
else
    clear rgbStack;
    rgbStack(zL,yL,3) = 0;
    if isempty(stackBlue)
        rgbStack(:,:,1) = norm0to1(maxintensityproj(stackRed,1)');
        rgbStack(:,:,2) = norm0to1(maxintensityproj(stack,1)');
        rgbStack(:,:,3) = 0;
        image(rgbStack);
    elseif isempty(stackRed)
        rgbStack(:,:,1) = 0;
        rgbStack(:,:,2) = norm0to1(maxintensityproj(stack,1)');
        rgbStack(:,:,3) = norm0to1(maxintensityproj(stackBlue,1)');
        image(rgbStack);
    else
        rgbStack(:,:,1) = norm0to1(maxintensityproj(stackRed,1)');
        rgbStack(:,:,2) = norm0to1(maxintensityproj(stack,1)');
        rgbStack(:,:,3) = norm0to1(maxintensityproj(stackBlue,1)');
        image(rgbStack);
    end
end

ylabel('z (steps)');
set(gca,'Ytick',zRange);
set(gca,'XTickLabel','');
set(gca,'Xtick',yRange);
box off;
if forPoster
    set(gca,'fontsize',10,'Xcolor','k','Ycolor','k');
    set(get(gca,'Title'),'Color','k');
else
    set(gca,'fontsize',10,'Xcolor','w','Ycolor','w');
    set(get(gca,'Title'),'Color','w');
end

if ~isempty(clustCent)
    hold on;plot(clustCent(2,:),clustCent(3,:),markerParam{:});
end

if ~isempty(nucVol)
    %     hold on;
    %     nucVolxy = maxintensityproj(nucVol,1);
    %     nucVolxy = maskToCoors(nucVolxy>0);
    %     K = convhull(nucVolxy(:,1),nucVolxy(:,2));
    %     plot(nucVolxy(K,1),nucVolxy(K,2),nucleiParam{:});
    traceBW(nucVol,1);
end

if ~isempty(segmentation)
    %     hold on;
    %     nucVolxy = maxintensityproj(nucVol,1);
    %     nucVolxy = maskToCoors(nucVolxy>0);
    %     K = convhull(nucVolxy(:,1),nucVolxy(:,2));
    %     plot(nucVolxy(K,1),nucVolxy(K,2),nucleiParam{:});
    traceBW(segmentation,1,segmentationParams{:});
end

if ~isempty(MLEtraj)
    xyzs = cellfun(@(x) x(1:3),MLEtraj,'UniformOutput',false);
    xyzs = cellfun(@(x) x',xyzs,'UniformOutput',false);
    xyzs = cell2mat(xyzs);
    c = 1:size(xyzs,2);
    x = xyzs(1,:)*0;
    y = xyzs(2,:);
    z = xyzs(3,:);
    surface([y(:), y(:)], [z(:), z(:)], [x(:), x(:)], ...
        [c(:), c(:)], 'EdgeColor','flat', 'FaceColor','none');
    %     colormap(gca,'default');
    hold on;
    plot(y(1),z(1),'r.','MarkerSize',10);
    plot(y(end),z(end),'g.','MarkerSize',10);
end


if ~isempty(spotParams)
    hold on;
    numSpots = numel(spotParams);
    colorSpots =  cool(numSpots);
    logLikeHoodsRatio = [spotParams.logLike];
    [logSorted,sortedI] = sort(logLikeHoodsRatio);
    for ii = 1:numSpots
        thetaMLE = cell2mat(spotParams(sortedI(ii)).thetaMLE);
        coordinate = thetaMLE(1:3);
        hold on; plot(coordinate(1),coordinate(3), markerParam{:},'markerEdgeColor',colorSpots(ii,:));
    end
end



%% last quadrant volume rendering------------------------------------------
if ~isempty(nucVol)
    subplot('Position',[4*border+relYDirY,1 - (2*border + relXDirZ + relXDirX),relYDirZ-border*2,relXDirZ-border*2]);
    %     nucVol = maskToCoors(nucVol>0);
    %     K = convhulln(nucVol);
    %     trisurf(K,nucVol(:,1),nucVol(:,2),nucVol(:,3),volumeParam{:});
    [node,~,face]=v2m(nucVol>0,0.5,5,100);
    plotmesh(node,face,volumeParam{:});
    set(gca,'DataAspectRatio',[1 1 (pixelSize/mag)/zStep]);
    axis([1 xL 1 yL 1 zL]);
    xlabel('x');
    ylabel('y');
    zlabel('z');
    grid on;
    if ~isempty(clustCent)
        hold on;
        if ~isempty(nucDists)
            for i = 1:size(nucDists,2)
                plot3(...
                    [clustCent(1,i),nucDists(1,i)],...
                    [clustCent(2,i),nucDists(2,i)],...
                    [clustCent(3,i),nucDists(3,i)],edgeParams{:});
            end
        end
        if ~isempty(pairWiseLines)
            plot3(pairWiseLines(:,1),pairWiseLines(:,2),pairWiseLines(:,3),pairWiseParam{:});
        end
        
        scatter3(clustCent(1,:),clustCent(2,:),clustCent(3,:),volMarkerParam{:});
        for i = 1:size(clustCent,2)
            hold on;
            plot3(...
                [clustCent(1,i),clustCent(1,i)],...
                [clustCent(2,i),clustCent(2,i)],...
                [clustCent(3,i),1],projParam{:});
        end
        %         for i = 1:size(clustCent,2)
        %             hold on;
        %             plot3(...
        %                 [clustCent(1,i),xL],...
        %                 [clustCent(2,i),clustCent(2,i)],...
        %                 [clustCent(3,i),clustCent(3,i)],projParam{:});
        %         end
        %         for i = 1:size(clustCent,2)
        %             hold on;
        %             plot3(...
        %                 [clustCent(1,i),clustCent(1,i)],...
        %                 [clustCent(2,i),yL],...
        %                 [clustCent(3,i),clustCent(3,i)],projParam{:});
        %         end
    end
    
else
    if ~isempty(enhanced)
        enhanced = norm0to1(enhanced);
        %enhanced = norm0to1(enhanced);
        subplot('Position',[4*border+relYDirY,1 - (2*border + relXDirZ + relXDirX),relYDirZ-border*2,relXDirZ-border*2]);
        if forPoster
            set(gca, 'color', [1 1 1]);
        end
        surfXY = maxintensityproj(enhanced,3);
        alphaXY = norm0to1(surfXY);
        surfXY = mat2gray(surfXY')*(256);
        %         surfXY = uint16(surfXY);
        %         surfXY = ind2rgb(surfXY,jet(256));
        
        surfXZ = maxintensityproj(enhanced,1);
        alphaXZ = norm0to1(surfXZ);
        surfXZ = mat2gray(surfXZ)*(256);
        %         surfXZ = uint16(surfXZ);
        %         surfXZ = ind2rgb(surfXZ,jet(256));
        
        surfYZ = maxintensityproj(enhanced,2);
        alphaYZ = norm0to1(surfYZ);
        surfYZ = mat2gray(surfYZ)*(256);
        %         surfYZ = uint16(surfYZ);
        %         surfYZ = ind2rgb(surfYZ,jet(256));
        %         enhanced = norm0to1(enhanced);
        %         alphaXY = mat2gray(maxintensityproj(enhanced,3));
        %         alphaXZ = mat2gray(maxintensityproj(enhanced,1));
        %         alphaYZ = mat2gray(maxintensityproj(enhanced,2));
        
        % for some reason the alpha map is shifted by 1 in both dims
        %         alphaXY = circshift(alphaXY,[-1,-1]);
        %         alphaXZ = circshift(alphaXZ,[-1,-1]);
        %         alphaYZ = circshift(alphaYZ,[-1,-1]);
        
        hold on;
        surfParams = {'EdgeColor','none','FaceAlpha','flat'};
        
        
        
        [sX,sY,sZ] = meshgrid(1:xL,1:yL,1);
        surface(sX,sY,sZ,double(surfXY),surfParams{:},'AlphaData',norm0to1(alphaXY'));
        [sX,sY,sZ] = meshgrid(xL,1:yL,1:zL);
        surface(reshape(sX,yL,zL),reshape(sY,yL,zL),reshape(sZ,yL,zL),double(surfXZ),surfParams{:},'AlphaData',norm0to1(alphaXZ));
        [sX,sY,sZ] = meshgrid(yL,1:xL,1:zL);
        surface(reshape(sY,xL,zL),reshape(sX,xL,zL),reshape(sZ,xL,zL),double(surfYZ),surfParams{:},'AlphaData',norm0to1(alphaYZ));
        grid on;
        view(3);
        colormap(gca,'default');
        axis tight;
        
        if ~isempty(clustCent)
            hold on;
            if ~isempty(nucDists)
                for i = 1:size(nucDists,2)
                    plot3(...
                        [clustCent(1,i),nucDists(1,i)],...
                        [clustCent(2,i),nucDists(2,i)],...
                        [clustCent(3,i),nucDists(3,i)],edgeParams{:});
                end
            end
            %             if ~isempty(pairWiseLines)
            %                 plot3(pairWiseLines(:,1),pairWiseLines(:,2),pairWiseLines(:,3),pairWiseParam{:});
            %             end
            
            scatter3(clustCent(1,:),clustCent(2,:),clustCent(3,:),volMarkerParam{:});
            for i = 1:size(clustCent,2)
                hold on;
                plot3(...
                    [clustCent(1,i),clustCent(1,i)],...
                    [clustCent(2,i),clustCent(2,i)],...
                    [clustCent(3,i),1],projParam{:});
                plot3(...
                    [clustCent(1,i),clustCent(1,i)],...
                    [clustCent(2,i),yL],...
                    [clustCent(3,i),clustCent(3,i)],projParam{:});
                plot3(...
                    [clustCent(1,i),xL],...
                    [clustCent(2,i),clustCent(2,i)],...
                    [clustCent(3,i),clustCent(3,i)],projParam{:});
            end
        end
        if ~isempty(MLEtraj)
            
            xyzs = cellfun(@(x) x(1:3),MLEtraj,'UniformOutput',false);
            xyzs = cellfun(@(x) x',xyzs,'UniformOutput',false);
            xyzs = cell2mat(xyzs);
            c = 1:size(xyzs,2);
            x = xyzs(1,:);
            y = xyzs(2,:);
            z = xyzs(3,:);
            surface([x(:), x(:)], [y(:), y(:)], [z(:), z(:)], ...
                [c(:), c(:)], 'EdgeColor','flat', 'FaceColor','none');
            colormap(gca,'default');
            
            
        end
    end
end
%% last quadrant-----------------------------------------------------------
if input.cBar == 1
    B = colorbar;
    set(B, 'Position', [3*border+relYDirY,1-(3*border+relXDirX+relXDirZ),border,relXDirZ]);
    box off;
    if forPoster
        set(B,'fontsize',9,'Xcolor','k','Ycolor','k');
    else
        set(B,'fontsize',9,'Xcolor','w','Ycolor','w');
    end
    
    if ~isempty(input.text)
        %ax = axes('position',[6*border+relYDirY,1-(3*border+relXDirX+relXDirZ),1-(7*border+relYDirY),relXDirZ],'visible','off');
        ax = axes('position',[0,1-border,border,border],'visible','off');
        txt = text(0,1,input.text);
        if forPoster
            set(txt,'fontsize',14,'Color','k','VerticalAlignment','top');
        else
            set(txt,'fontsize',14,'Color','w','VerticalAlignment','top');
        end
        
    end
else
    if ~isempty(input.text)
        %ax = axes('position',[3*border+relYDirY,1-(3*border+relXDirX+relXDirZ),1-(4*border+relYDirY),relXDirZ],'visible','off');
        ax = axes('position',[0,1-border,border,border],'visible','off');
        txt = text(0,1,input.text);
        if forPoster
            set(txt,'fontsize',14,'Color','k','VerticalAlignment','top');
        else
            set(txt,'fontsize',14,'Color','w','VerticalAlignment','top');
        end
    end
end

if ~isempty(MLEtraj)
    figure;
    amps = cellfun(@(x)x(end),MLEtraj);
    bkgnds = cellfun(@(x)x(end-1)^2,MLEtraj);
    [hAx,hLine1,hLine2] =plotyy(1:numel(amps),amps,1:numel(bkgnds),bkgnds);
    xlabel('MLE iteration');
    ylabel(hAx(1),'amplitude') % left y-axis
    ylabel(hAx(2),'background') % left y-axis
    firstxyz = xyzs(:,1);
    xyzdistances = bsxfun(@minus,xyzs',firstxyz');
    xyzdistances = sqrt(sum(xyzdistances.^2,2));
    figure;
    plot(1:numel(xyzdistances),xyzdistances);
    xlabel('MLE iteration');
    ylabel('distance from initial xyz estimate (voxels)');
end
end


