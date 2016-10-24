function [] = plotIdx(domains,data,x0,y0,z0)
%ADSF Summary of this function goes here
%   Detailed explanation goes here

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
    imagesc(minDom(2),minDom(1),maxintensityproj(nDData,3));axis square;box off;hold on;plot(y0,x0,'sr');xlabel('y');ylabel('x');
    colormap(gray);
end

