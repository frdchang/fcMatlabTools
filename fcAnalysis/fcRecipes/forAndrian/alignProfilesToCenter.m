function aligned = alignProfilesToCenter(data,coordinateOfInterest)
%ALIGNPROFILESTOCENTER to shift the data with its coordinateOfInterest to
%the center of the data

sizeData = size(data);
centerOfData = round(sizeData/2);
shiftAmount = centerOfData - coordinateOfInterest;
aligned = circshift(data,shiftAmount);


