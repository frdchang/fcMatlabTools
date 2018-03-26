function L = genLfromROIzip(filePathToROIzip,sizeOfData)
%GENLFROMROIZIP will generate a label matrix L from the imagej ROI zip file

[sROI] = ReadImageJROI(filePathToROIzip);

numObjects = numel(sROI);
L = zeros(sizeOfData);
for ii = 1:numObjects
   currObj = ii* poly2mask(sROI{ii}.mnCoordinates(:,1)+1,sROI{ii}.mnCoordinates(:,2)+1,sizeOfData(1),sizeOfData(2));
   L(currObj>0) = currObj(currObj>0);
end


