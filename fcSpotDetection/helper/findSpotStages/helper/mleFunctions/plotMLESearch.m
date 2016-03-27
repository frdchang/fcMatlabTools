function h = plotMLESearch(theta,data,iter,titleText)
%PLOT3DGRADSEARCH 
theta = num2cell(theta);
[x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak] = deal(theta{:});
persistent oldParam;
persistent prevIter;

if iter == 0
    close all;
    h = createMaxFigure();
    
    subplot(5,1,1);
    imagesc(maxintensityproj(data,1));axis equal;box off;hold on;plot(z0,y0,'sr');title(titleText);
    subplot(5,1,2);
    imagesc(maxintensityproj(data,2));axis equal;box off;hold on;plot(z0,x0,'sr');
    subplot(5,1,3); 
    imagesc(maxintensityproj(data,3));axis equal;box off;hold on;plot(y0,x0,'sr');
    colormap gray;
    subplot(5,1,4);plot(iter,Amp,'sr'); title('amp');
    subplot(5,1,5);plot(iter,Bak,'sk'); title('bak');
    oldParam = theta;
    prevIter = 0;
    drawnow;
else
    [last_x0,last_y0,last_z0,last_sigXsq,last_sigYsq,last_sigZsq,last_Amp,last_Bak] = deal(oldParam{:});
    
    subplot(5,1,1);hold on;plot([last_z0 z0],[last_y0 y0],'-r');
    subplot(5,1,2);hold on;plot([last_z0 z0],[last_x0 x0],'-r');
    subplot(5,1,3);hold on;plot([last_y0 y0],[last_x0 x0],'-r');
    subplot(5,1,4);hold on;plot([prevIter iter],[last_Amp,Amp],'-sr'); title('amp');
    subplot(5,1,5);hold on;plot([prevIter iter],[last_Bak,Bak],'-sk'); title('bak');
    oldParam = theta;
    prevIter = iter;
    drawnow;
end

