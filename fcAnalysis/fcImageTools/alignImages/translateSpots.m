function outputFiles = translateSpots(listOfMLEs,translationSequence,varargin)
%TRANSLATESPOTS assumes thetaMLE xy dimensions are the first two positions
%in the thetaMLE field of the structure

outputFiles = cell(numel(listOfMLEs),1);

for ii = 1:numel(listOfMLEs)
   shiftedSpots = listOfMLEs{ii};
   for jj = 1:numel(shiftedSpots)
       currTheta = shiftedSpots{jj}.thetaMLE;
       currTheta = cell2mat(currTheta);
       translationXY = zeros(size(currTheta));
       translationXY(2) = translationSequence(ii,1);
       translationXY(1) = translationSequence(ii,2);
       currThetaShifted = currTheta+translationXY;
       shiftedSpots(jj).thetaMLE = num2cell(currThetaShifted);
   end
   saveProcessedFileAt = genProcessedFileName(listOfMLEs{ii},'translateSpots');
   makeDIRforFilename(saveProcessedFileAt);
   save(saveProcessedFileAt,'shiftedSpots');
   outputFiles{ii} = [saveProcessedFileAt '.mat'];
end



