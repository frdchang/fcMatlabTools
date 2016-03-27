function h = plotSynSpots(synSpotStruct)
%PLOTSYNSPOTS plots synthetic spot dataset

spotList = synSpotStruct.synSpotList;
spotList = cell2mat(spotList);
clustCent = [[spotList.xPixel];[spotList.yPixel];[spotList.zPixel]];
h = plot3Dstack(synSpotStruct.data,'clustCent',clustCent);
end

