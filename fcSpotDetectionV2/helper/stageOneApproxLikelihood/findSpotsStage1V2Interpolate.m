function [estimated] = findSpotsStage1V2Interpolate(data,spotKern,cameraVariance)
%FINDSPOTSSTAGE1V2INTERPOLATE spotKern is provided as a shifted version
%then this will interpolate the estimates
sizeData = size(data);
outputs = cell(size(spotKern));
for ii = 1:size(outputs,1)
    for jj = 1:size(outputs,2)
        for kk = 1:size(outputs,3)
            outputs{ii,jj,kk} = findSpotsStage1V2(data,spotKern{ii,jj,kk},cameraVariance);
        end
    end
end

sizeOutputs = size(outputs);
updateFields = {'A0','A1','B1','B0','LLRatio'};
estimated = [];
for ii = 1:numel(updateFields)
    estimated.(updateFields{ii}) = doInterpForField(sizeData,sizeOutputs,outputs,updateFields{ii});
end

end


function myInterp = doInterpForField(sizeData,sizeOutputs,outputs,theField)

myInterp = zeros(sizeData.*sizeOutputs);
for ii = 1:size(outputs,1)
    for jj = 1:size(outputs,2)
        for kk = 1:size(outputs,3)
            myInterp(ii:sizeOutputs(1):end,jj:sizeOutputs(2):end,kk:sizeOutputs(3):end) = outputs{ii,jj,kk}.(theField);
        end
    end
end

end