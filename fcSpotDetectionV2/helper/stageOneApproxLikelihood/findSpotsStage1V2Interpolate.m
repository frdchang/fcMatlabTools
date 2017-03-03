function [ estimated ] = findSpotsStage1V2Interpolate(data,spotKern,cameraVariance)
%FINDSPOTSSTAGE1V2INTERPOLATE spotKern is provided as a shifted version
%then this will interpolate the estimates

outputs = cell(size(spotKern));
for ii = 1:size(outputs,1)
    for jj = 1:size(outputs,2)
        for kk = 1:size(outputs,3)
            outputs{ii,jj,kk} = findSpotsStage1V2(data,spotKern{ii,jj,kk},cameraVariance);
        end
    end
end

numInterpolate = size(outputs);
A1 = zeros(size(data).*numInterpolate);

end




