function h = plotMLESearchV2(carvedMask,A1s,datas,theta0s,domains,totalIter,error)
%PLOTMLESEARCHV2 Summary of this function goes here
%PLOT3DGRADSEARCH

persistent oldParam;
persistent prevIter;
persistent prevError;

yzIdx = [false false true true];
zxIdx = [false true false true];
yxIdx = [false true true false];
ampIdx = [true false false false];
numDatas = numel(datas);
% datas = convertLinearDomainToND(domains,datas);
for ii = 1:numel(A1s)
   A1s{ii}(~carvedMask) = NaN; 
end
concatData = catenateCellofDatas(A1s);
if totalIter == 1
    close all;
    minDomains = cellfun(@(x) min(x(:)),domains);
    maxDomains = cellfun(@(x) max(x(:)),domains);
    h = createMaxFigure();
    subplot(2,2,3);
    imagesc(minDomains(2),minDomains(3),maxintensityproj(concatData,1)');axis equal;axis([minDomains(2) maxDomains(2)*numDatas minDomains(3) maxDomains(3)]);box off;hold on;xlabel('y');ylabel('z');%plot(y0,z0,'sr');
    thisSize = size(maxintensityproj(concatData,1)');
    for ii = 2:numel(theta0s)
        if iscell(theta0s{ii})
            for jj = 1:numel(theta0s{ii})
                if isobject(theta0s{ii}{jj}{1})
                    patternTheta = theta0s{ii}{jj}{2:end};
                    yzplotVals = patternTheta(yzIdx);
                    plot(yzplotVals(1) + (ii-2)*thisSize(2)/numDatas,yzplotVals(2),'sr');
                end
            end
        end
    end
    
    for ii = 2:numDatas+1
        plot([(ii-2)*thisSize(2)/numDatas,(ii-2)*thisSize(2)/numDatas],[minDomains(2) maxDomains(3)+1],'--w');
    end
%     subplot(2,2,2);
%     imagesc(minDomains(3),minDomains(1),maxintensityproj(concatData,2));axis square;box off;hold on;xlabel('z');ylabel('x');%plot(z0,x0,'sr')
%     for ii = 2:numel(theta0s)
%         if iscell(theta0s{ii})
%             for jj = 1:numel(theta0s{ii})
%                 if isobject(theta0s{ii}{jj}{1})
%                     patternTheta = theta0s{ii}{jj}{2:end};
%                     zxplotVals = patternTheta(zxIdx);
%                     plot(zxplotVals(2),zxplotVals(1),'sr');
%                 end
%             end
%         end
%     end
%     
    
    subplot(2,2,1);
    imagesc(minDomains(2),minDomains(1),maxintensityproj(concatData,3));axis equal;axis([minDomains(2) maxDomains(2)*numDatas minDomains(1) maxDomains(1)]);box off;hold on;xlabel('y');ylabel('x');%plot(y0,x0,'sr');
    thisSize = size(maxintensityproj(concatData,3));
    for ii = 2:numel(theta0s)
        if iscell(theta0s{ii})
            for jj = 1:numel(theta0s{ii})
                if isobject(theta0s{ii}{jj}{1})
                    patternTheta = theta0s{ii}{jj}{2:end};
                    yxplotVals = patternTheta(yxIdx);
                    plot(yxplotVals(2)+ (ii-2)*thisSize(2)/numDatas,yxplotVals(1),'sr');
                end
            end
        end
    end
    
       for ii = 2:numDatas+1
        plot([(ii-2)*thisSize(2)/numDatas,(ii-2)*thisSize(2)/numDatas],[minDomains(2) maxDomains(1)+1],'--w');
    end
    
    colormap gray;
    subplot(2,2,4);
    for ii = 2:numel(theta0s)
        if iscell(theta0s{ii})
            for jj = 1:numel(theta0s{ii})
                if isobject(theta0s{ii}{jj}{1})
                    patternTheta = theta0s{ii}{jj}{2:end};
                    ampplotVals = patternTheta(ampIdx);
                    plot(totalIter,ampplotVals,'sr'); hold on;
                else
                    plot(totalIter,theta0s{ii}{jj}{1},'sk');
                end
            end
        end
    end
    
     subplot(2,2,2);
    plot( [totalIter],[error],'-sg');
       
    prevError = error;   
    oldParam = theta0s;
    prevIter = totalIter;
    drawnow;
else
    subplot(2,2,3);
    thisSize = size(maxintensityproj(concatData,1)');
    for ii = 2:numel(theta0s)
        if iscell(theta0s{ii})
            for jj = 1:numel(theta0s{ii})
                if isobject(theta0s{ii}{jj}{1})
                    patternTheta = theta0s{ii}{jj}{2:end};
                    yzplotVals = patternTheta(yzIdx);
                    prevyzplotVals = oldParam{ii}{jj}{2:end}(yzIdx);
                    hold on;plot([prevyzplotVals(1)+ (ii-2)*thisSize(2)/numDatas, yzplotVals(1)+ (ii-2)*thisSize(2)/numDatas],[prevyzplotVals(2) yzplotVals(2)],'-r');
                end
            end
        end
    end
    
%     subplot(2,2,2);
%     for ii = 2:numel(theta0s)
%         if iscell(theta0s{ii})
%             for jj = 1:numel(theta0s{ii})
%                 if isobject(theta0s{ii}{jj}{1})
%                     patternTheta = theta0s{ii}{jj}{2:end};
%                     zxplotVals = patternTheta(zxIdx);
%                     prevzxplotVals = oldParam{ii}{jj}{2:end}(zxIdx);
%                     plot([prevzxplotVals(2), zxplotVals(2)],[prevzxplotVals(1) zxplotVals(1)],'-r');
%                 end
%             end
%         end
%     end
    
    
    subplot(2,2,1);
     thisSize = size(maxintensityproj(concatData,3));
    for ii = 2:numel(theta0s)
        if iscell(theta0s{ii})
            for jj = 1:numel(theta0s{ii})
                if isobject(theta0s{ii}{jj}{1})
                    patternTheta = theta0s{ii}{jj}{2:end};
                    yxplotVals = patternTheta(yxIdx);
                    prevyxplotVals = oldParam{ii}{jj}{2:end}(yxIdx);
                    plot([prevyxplotVals(2)+ (ii-2)*thisSize(2)/numDatas, yxplotVals(2)+ (ii-2)*thisSize(2)/numDatas],[prevyxplotVals(1) yxplotVals(1)],'-r');
                end
            end
        end
    end
    
    colormap gray;
    subplot(2,2,4);
    for ii = 2:numel(theta0s)
        if iscell(theta0s{ii})
            for jj = 1:numel(theta0s{ii})
                if isobject(theta0s{ii}{jj}{1})
                    patternTheta = theta0s{ii}{jj}{2:end};
                    ampplotVals = patternTheta(ampIdx);
                    prevampplotVals = oldParam{ii}{jj}{2:end}(ampIdx);
                    hold on;plot([prevIter,totalIter],[prevampplotVals ampplotVals],'-sr'); 
                else
                    hold on;plot([prevIter,totalIter],[oldParam{ii}{jj}{1} theta0s{ii}{jj}{1}],'-sk');
                end
            end
        end
    end
    
    subplot(2,2,2);
    
       hold on;plot( [prevIter,totalIter],[prevError,error],'-sg');

    prevError = error;
    oldParam = theta0s;    
    prevIter = totalIter;
    drawnow;
end

