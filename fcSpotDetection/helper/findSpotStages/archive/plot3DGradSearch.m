function h = plot3DGradSearch(param,data,iter)
%PLOT3DGRADSEARCH Summary of this function goes here
%   Detailed explanation goes here
persistent oldParam;
persistent prevIter;
if iter == 0
    h = createMaxFigure();
    subplot(5,1,1);
    imagesc(maxintensityproj(data,1));axis equal;box off;hold on;plot(param(5),param(4),'sr');
    subplot(5,1,2);
    imagesc(maxintensityproj(data,2));axis equal;box off;hold on;plot(param(5),param(3),'sr');
    subplot(5,1,3); 
    imagesc(maxintensityproj(data,3));axis equal;box off;hold on;plot(param(4),param(3),'sr');
    colormap gray;
    subplot(5,1,4);plot(iter,param(1),'sr'); title('amp');
    subplot(5,1,5);plot(iter,param(2),'sk'); title('bak');
    oldParam = param;
    prevIter = 0;
    drawnow;
else
    subplot(5,1,1);hold on;plot([oldParam(5) param(5)],[oldParam(4) param(4)],'-r');
    subplot(5,1,2);hold on;plot([oldParam(5) param(5)],[oldParam(3) param(3)],'-r');
    subplot(5,1,3);hold on;plot([oldParam(4) param(4)],[oldParam(3) param(3)],'-r');
    subplot(5,1,4);hold on;plot([prevIter iter],[oldParam(1),param(1)],'-sr'); title('amp');
    subplot(5,1,5);hold on;plot([prevIter iter],[oldParam(2),param(2)],'-sk'); title('bak');
    oldParam = param;
    prevIter = iter;
    drawnow;
end

