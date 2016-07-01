function theta = genThetaFromSynSpotStruct_for_single3DGauss(synSpotStruct)
%GENTHETAFROMSYNSPOT_FOR_SINGLE3DGAUSS will take the output of
% genSyntheticSpot output of synSpotList{i} which is a synSpotStruct of
% information of the synthetic spot.  This function will generate a theta
% vector appropriate for the lambda_single3DGuass if the synthetic spot was
% generated with a 3D gaussian.  


theta = {synSpotStruct.yPixel,synSpotStruct.xPixel,synSpotStruct.zPixel,...
    synSpotStruct.sigmaxy^2,synSpotStruct.sigmaxy^2,synSpotStruct.sigmaz^2,...
    synSpotStruct.amp,synSpotStruct.bak};
end

