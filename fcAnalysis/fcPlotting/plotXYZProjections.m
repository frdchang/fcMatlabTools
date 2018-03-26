function [ h ] = plotXYZProjections( psf )
%PLOTXYZPROJECTIONS will plot a cube with xyz projections
surfParams = {'EdgeColor','none'};
axisParams = {'-','Color',[1,1,1],'LineWidth',2};
psf = norm0to1(psf);
[xL,yL,zL] = size(psf);
surfXY = maxintensityproj(psf,3);
surfXY = surfXY';
surfXZ = maxintensityproj(psf,1);





hold on;
surfYZ = maxintensityproj(psf,2);
[sX,sY,sZ] = meshgrid(0:xL-1,0:yL-1,0);
surface(sX,sY,sZ,repmat(surfXY,1,1,3),surfParams{:});
hold on;
[sX,sY,sZ] = meshgrid(xL-1,0:yL-1,0:zL-1);
surface(reshape(sX,yL,zL),reshape(sY,yL,zL),reshape(sZ,yL,zL),repmat(surfXZ,1,1,3),surfParams{:});
[sX,sY,sZ] = meshgrid(yL-1,0:xL-1,0:zL-1);
surface(reshape(sY,xL,zL),reshape(sX,xL,zL),reshape(sZ,xL,zL),repmat(surfYZ,1,1,3),surfParams{:});

plot3([0,xL-1],[yL-1,yL-1],[zL-1,zL-1],axisParams{:});
plot3([xL-1,xL-1],[yL-1,yL-1],[0,zL-1],axisParams{:});
plot3([xL-1,xL-1],[0,yL-1],[zL-1,zL-1],axisParams{:});


plot3([xL-1,xL-1],[yL-1,yL-1],[zL-1,0],axisParams{:});
plot3([0,0],[yL-1,yL-1],[zL-1,0],axisParams{:});
plot3([xL-1,xL-1],[0,0],[zL-1,0],axisParams{:});

plot3([0,xL-1],[yL-1,yL-1],[0,0],axisParams{:});
plot3([xL-1,xL-1],[0,yL-1],[0,0],axisParams{:});

