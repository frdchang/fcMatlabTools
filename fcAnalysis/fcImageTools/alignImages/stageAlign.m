function [xyAlignments] = stageAlign(fileList,varargin)
%ALIGNSTAGE will load each nd image from fileList and align from frame 1
% and will only align the maximum intensity projected in XY.

%--parameters--------------------------------------------------------------
params.upSampling  = 100;
params.saveToLocation = [];
%--------------------------------------------------------------------------
params = updateParams(params,varargin);


xyAlignments = zeros(numel(fileList),2);


display(['stageAlign(' returnFileName(fileList{1}) ')     ' num2str(1) ' of ' num2str(numel(fileList))]);
refFrame = fileList{1};
refFrame = importStack(refFrame);
refFrameMAX = xyMaxProjND(refFrame);
xyAlignments(1,:) = [0,0];
fftRefFrame = fft2(refFrameMAX);

if ~isempty(params.saveToLocation)
    exportStack(genSaveFile(params.saveToLocation,returnFileName(fileList{1})),refFrame);
end

for ii = 2:numel(fileList)
    display(['stageAlign(' returnFileName(fileList{ii}) ')     ' num2str(ii) ' of ' num2str(numel(fileList))]);
    currFrame = importStack(fileList{ii});
    currFrameMAX = xyMaxProjND(currFrame);
    fftCurrFrame = fft2(currFrameMAX);
    [output , shiftedFrame] = dftregistration(fftRefFrame,fftCurrFrame,params.upSampling);
    fftRefFrame = shiftedFrame;
    xyAlignments(ii,:) = output(3:end);
    if ~isempty(params.saveToLocation)
        exportStack(genSaveFile(params.saveToLocation,returnFileName(fileList{ii})),real(ifft2(shiftedFrame)));
    end
end

