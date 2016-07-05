function yourData = grabScatteredData(filePath,dataMarkers,openDataFunc)
%GRABSCATTEREDDATA will go find all the data files in filePath regexp
%marked by dataMarkers and apply openDataFunc on those hits, then return a
%cell array yourData containing those outputs.

dataFileNames = getAllFiles(filePath,dataMarkers);
datas = cell(numel(dataFileNames),1);

for i = 1:numel(datas)
   datas{i} = openDataFunc(dataFileNames{i}); 
end

yourData.dataFileNames = dataFileNames;
yourData.datas         = datas;

