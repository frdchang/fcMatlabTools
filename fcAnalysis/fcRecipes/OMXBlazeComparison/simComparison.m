camVarE = importStack('/Users/frederickchang/Dropbox/Public/OMXBlaze/camVarInElectrons.fits');
offsetInADU = importStack('/Users/frederickchang/Dropbox/Public/OMXBlaze/offsetInADU.fits');
wfStack = importStack('/Users/frederickchang/Dropbox/Public/OMXBlaze/tif-wf/Ecoli_mcherryHU_1520_007_WF.tif');
cameraParamStruct.QE = 0.72;
cameraParamStruct.offsetInAdu = offsetInADU;
cameraParamStruct.gainElectronPerCount = 0.49;
electronStack = returnElectrons(wfStack,cameraParamStruct);


zSteps = 12;
use_z  = 9;

camVarE = repmat(camVarE,1,1,zSteps);
spotKern = ndGauss([1.3,1.3,1.3],[7,7,7]);
sizeStack = size(electronStack);
timeSteps = sizeStack(3)/zSteps;
timePoints = cell(timeSteps,1);
for ii = 1:timeSteps
    f_idx = zSteps*(ii-1)+1;
    l_idx = zSteps*(ii-1) + zSteps;
    timePoints{ii} = electronStack(:,:,f_idx:l_idx);
end

estimated = cell(timeSteps,1);
setupParForProgress(timeSteps);
for ii = 1:timeSteps
    incrementParForProgress();
    estimated{ii} = findSpotsStage1V2(timePoints{ii},spotKern,camVarE);
end

A1z = zeros(sizeStack(1),sizeStack(2),timeSteps);
LLz = A1z;

for ii = 1:timeSteps
   A1z(:,:,ii) = estimated{ii}.A1(:,:,use_z);
   LLz(:,:,ii) = estimated{ii}.LLRatio(:,:,use_z);
end

exportSingleFitsStack('~/Desktop/A1z',A1z);
exportSingleFitsStack('~/Desktop/LLz',LLz);




