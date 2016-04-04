function h = plotMLESearch(theta,data,domains,iter,titleText,type)
%PLOT3DGRADSEARCH
theta = num2cell(theta);
[x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak] = deal(theta{:});
persistent oldParam;
persistent prevIter;

switch type
    case 1
        close all;
    case 2
        close all;
    case 3
        if isequal(titleText,'gradient MLE') && iter == 0
            close all;
            prevIter = 0;
        else
            iter = prevIter + iter;
        end
    otherwise
        error('type is not 1 2 or 3');
end

if iter == 0
    %% setup data volume if it is not in its nd shape
    minDom = min([domains{:}]);
    maxDom = max([domains{:}]);
    nDData = ones(maxDom-minDom+1)*min(data(:))-1;
    indices = num2cell(bsxfun(@minus,[domains{:}],minDom)+1,1);
    linearIndices = sub2ind(size(nDData),indices{:});
    nDData(linearIndices) = data;
    h = createMaxFigure();
    subplot(4,4,[9 10 13 14]);
    imagesc(minDom(2),minDom(3),maxintensityproj(nDData,1)');axis square;box off;hold on;plot(y0,z0,'sr');xlabel('y');ylabel('z');
    subplot(4,4,[3 4 7 8]);
    imagesc(minDom(3),minDom(1),maxintensityproj(nDData,2));axis square;box off;hold on;plot(z0,x0,'sr');xlabel('z');ylabel('x');
    subplot(4,4,[1 2 5 6]);
    imagesc(minDom(2),minDom(1),maxintensityproj(nDData,3));axis square;box off;hold on;plot(y0,x0,'sr');xlabel('y');ylabel('x');title(titleText)
    colormap gray;
    subplot(4,4,[11 12]);plot(iter,Amp,'sr'); title('amp');
    subplot(4,4,[15 16]);plot(iter,Bak,'sk'); title('bak');
    oldParam = theta;
    prevIter = 0;
    drawnow;
else
    [last_x0,last_y0,last_z0,last_sigXsq,last_sigYsq,last_sigZsq,last_Amp,last_Bak] = deal(oldParam{:});
    subplot(4,4,[9 10 13 14]);hold on;plot([last_y0 y0],[last_z0 z0],'-r');
    subplot(4,4,[3 4 7 8]);hold on;plot([last_z0 z0],[last_x0 x0],'-r');
    subplot(4,4,[1 2 5 6]);hold on;plot([last_y0 y0],[last_x0 x0],'-r');
    subplot(4,4,[11 12]);hold on;plot([prevIter iter],[last_Amp,Amp],'-sr'); title('amp');
    subplot(4,4,[15 16]);hold on;plot([prevIter iter],[last_Bak,Bak],'-sk'); title('bak');
    oldParam = theta;
    prevIter = iter;
    drawnow;
end

