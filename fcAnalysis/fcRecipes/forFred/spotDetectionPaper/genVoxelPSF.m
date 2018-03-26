function H = genVoxelPSF(psf,centerCoor)
%GENVOXELPSF Summary of this function goes here
%   Detailed explanation goes here
psfThresh = 0.025;
surfParams = {'EdgeColor','none'};
axisParams = {'-','Color',[1,1,1],'LineWidth',2};
coorParams = {'-','Color',[1,0,0]};
angle = -45;
elevation = 20;
axisOff = 'off';
openFlaps = 1;
axisRatio = [1 1 1.5];
bkgnd = [0.2,0.2,0.2];

alpha = psf > psfThresh;
% plot3Dstack(alpha);drawnow;close all;
idx = alpha > 0;
logPSF = log(psf);
reMapAlpha = norm0to1(logPSF(idx));
alpha = zeros(size(logPSF));
alpha(idx) = reMapAlpha;
alpha(1:centerCoor(1),1:centerCoor(2)-1,:) = 0;
alpha(1:centerCoor(1)-1,1:centerCoor(2),:) = 0;

alpha(centerCoor(1)+1:end,centerCoor(2)+1:end,:) = 0;
% alpha(centerCoor(1)+1:end,centerCoor(2):end,:) = 0;

% alpha(1:centerCoor(1)+1:end,centerCoor(2):end) = 0;

volData = logPSF;
volData(~idx) = min(logPSF(idx));
% alpha(alpha<0.1 & alpha > 0) = 0.1;
createFullMaxFigure();
if openFlaps ~= 1
H=vol3d('CData',volData,'Alpha',alpha);
end
[xL,yL,zL] = size(psf);
surfXY = maxintensityproj(psf,3);
surfXY = surfXY';
%         surfXY = uint16(surfXY);
%         surfXY = ind2rgb(surfXY,jet(256));

surfXZ = maxintensityproj(psf,1);
%         surfXZ = uint16(surfXZ);
%         surfXZ = ind2rgb(surfXZ,jet(256));

surfYZ = maxintensityproj(psf,2);
%         surfYZ = uint16(surfYZ);
%         surfYZ = ind2rgb(surfYZ,jet(256));
%         psf = norm0to1(psf);
%         alphaXY = mat2gray(maxintensityproj(psf,3));
%         alphaXZ = mat2gray(maxintensityproj(psf,1));
%         alphaYZ = mat2gray(maxintensityproj(psf,2));

% for some reason the alpha map is shifted by 1 in both dims
%         alphaXY = circshift(alphaXY,[-1,-1]);
%         alphaXZ = circshift(alphaXZ,[-1,-1]);
%         alphaYZ = circshift(alphaYZ,[-1,-1]);

hold on;


if openFlaps == 1
    
    [sX,sY,sZ] = meshgrid(0:xL-1,0:yL-1,0);
    surface(sX,sY,sZ,repmat(surfXY,1,1,3),surfParams{:});
    [sX,sY,sZ] = meshgrid(xL-1,0:yL-1,0:zL-1);
    surface(reshape(sX,yL,zL),reshape(sY,yL,zL),reshape(sZ,yL,zL),repmat(surfXZ,1,1,3),surfParams{:});
    [sX,sY,sZ] = meshgrid(yL-1,0:xL-1,0:zL-1);
    surface(reshape(sY,xL,zL),reshape(sX,xL,zL),reshape(sZ,xL,zL),repmat(surfYZ,1,1,3),surfParams{:});

    view(angle,elevation);
        plot3([0,xL-1],[yL-1,yL-1],[zL-1,zL-1],axisParams{:});
    plot3([xL-1,xL-1],[yL-1,yL-1],[0,zL-1],axisParams{:});
    plot3([xL-1,xL-1],[0,yL-1],[zL-1,zL-1],axisParams{:});
    
    
    plot3([xL-1,xL-1],[yL-1,yL-1],[zL-1,0],axisParams{:});
    plot3([0,0],[yL-1,yL-1],[zL-1,0],axisParams{:});
    plot3([xL-1,xL-1],[0,0],[zL-1,0],axisParams{:});
elseif openFlaps == 2
    [sX,sY,sZ] = meshgrid(0:xL-1,0:yL-1,0);
    surface(sX,sY,sZ,repmat(surfXY,1,1,3),surfParams{:});
    [sX,sY,sZ] = meshgrid(xL-1,0:yL-1,0:zL-1);
    sX = xL-1+ (yL/zL)*sZ;
    sZ = sZ*1/sqrt(2);
    surface(reshape(sX,yL,zL),reshape(sY,yL,zL),reshape(sZ,yL,zL),repmat(surfXZ,1,1,3),surfParams{:});
    [sX,sY,sZ] = meshgrid(yL-1,0:xL-1,0:zL-1);
    sX = xL-1+ (yL/zL)*sZ;
    sZ = sZ*1/sqrt(2);
    surface(reshape(sY,xL,zL),reshape(sX,xL,zL),reshape(sZ,xL,zL),repmat(surfYZ,1,1,3),surfParams{:});
    plot3([0,xL-1],[yL-1,yL-1],[zL-1,zL-1],axisParams{:});
    plot3([xL-1,xL-1],[yL-1,yL-1],[0,zL-1],axisParams{:});
    plot3([xL-1,xL-1],[0,yL-1],[zL-1,zL-1],axisParams{:});
    
    
    plot3([xL-1,xL-1],[yL-1,yL-1],[zL-1,0],axisParams{:});
    plot3([0,0],[yL-1,yL-1],[zL-1,0],axisParams{:});
    plot3([xL-1,xL-1],[0,0],[zL-1,0],axisParams{:});
    
    bg_color = get(gca,'Color');
    set(gca,'ZColor',bg_color,'ZTick',[])
else 
    [sX,sY,sZ] = meshgrid(0:xL-1,0:yL-1,0);
    surface(sX,sY,sZ,repmat(surfXY,1,1,3),surfParams{:});hold on;
    [sX,sY,sZ] = meshgrid(xL-1,0:yL-1,0:zL-1);
    sX = xL-1+ (yL/zL)*sZ;
    sZ = sZ*0;
    surface(reshape(sX,yL,zL),reshape(sY,yL,zL),reshape(sZ,yL,zL),repmat(surfXZ,1,1,3),surfParams{:});
    [sX,sY,sZ] = meshgrid(yL-1,0:xL-1,0:zL-1);
    sX = xL-1+ (yL/zL)*sZ;
    sZ = sZ*0;
    surface(reshape(sY,xL,zL),reshape(sX,xL,zL),reshape(sZ,xL,zL),repmat(surfYZ,1,1,3),surfParams{:});
    plot3([0,xL-1],[yL-1,yL-1],[zL-1,zL-1],axisParams{:});
    plot3([xL-1,xL-1],[yL-1,yL-1],[0,zL-1],axisParams{:});
    plot3([xL-1,xL-1],[0,yL-1],[zL-1,zL-1],axisParams{:});
    
    
    plot3([xL-1,xL-1],[yL-1,yL-1],[zL-1,0],axisParams{:});
    plot3([0,0],[yL-1,yL-1],[zL-1,0],axisParams{:});
    plot3([xL-1,xL-1],[0,0],[zL-1,0],axisParams{:});
    
    bg_color = get(gca,'Color');
    set(gca,'ZColor',bg_color,'ZTick',[])
end


axis tight;
set(gca,'XTick',5:10:xL-1);
set(gca,'YTick',5:10:yL-1);
set(gca,'ZTick',5:5:zL-1);

%% plot the lines for boxes

plot3([0,xL-1],[yL-1,yL-1],[0,0],axisParams{:});
plot3([xL-1,xL-1],[yL-1,yL-1],[0,zL-1],axisParams{:});
plot3([xL-1,xL-1],[0,yL-1],[0,0],axisParams{:});

if openFlaps ==1
    set(gca,'XLim',[0,xL-1]);
    set(gca,'YLim',[0 yL-1]);
    set(gca,'ZLim',[0 zL-1]);
end

%% plot the lines for coordinate
myCoor = centerCoor - 0.5;
plot3(...
    [myCoor(1),myCoor(1)],...
    [myCoor(2),myCoor(2)],...
    [myCoor(3),0],coorParams{:},'LineWidth',2);
plot3(...
    [myCoor(1),myCoor(1)],...
    [myCoor(2),yL-1],...
    [myCoor(3),myCoor(3)],coorParams{:},'LineWidth',2);
plot3(...
    [myCoor(1),xL-1],...
    [myCoor(2),myCoor(2)],...
    [myCoor(3),myCoor(3)],coorParams{:},'LineWidth',2);

axis(axisOff);
pbaspect(axisRatio);
whitebg(bkgnd);
set(gcf,'color',bkgnd);
