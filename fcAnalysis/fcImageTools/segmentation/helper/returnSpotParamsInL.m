function spotParamsInL = returnSpotParamsInL(spotParams,L,varargin)
%UNIONBWMASKANDSPOTPARAMS will return the spot params in L

spots = zeros(size(L));
maxCells = max(L(:));
spotParamsInL = cell(maxCells,1);

for eachSpot = 1:numel(spotParams)
    currSingleSpotTheta = getOneSpotTheta(spotParams{eachSpot});
    if isempty(currSingleSpotTheta)
        continue;
    end
    if strcmp(currSingleSpotTheta.stateOfStep,'ok')
        xyzCoor = getSpotCoorsFromTheta(currSingleSpotTheta.thetaMLEs);
        xyzCoor = xyzCoor{1};
        if ismatrix(L)
            currCoor = xyzCoor([1 2]);
            currCoor = round(currCoor);
            currCoor = num2cell(currCoor);
            % need to check if currCorr is within domain
            if currCoor{1} <= size(spots,1) && currCoor{2} <= size(spots,2) && currCoor{1} >= 1 && currCoor{2} >=1
                spots(currCoor{:}) = eachSpot;
            end
        elseif ndims(L) == 3
            currCoor = xyzCoor([1 2 3]);
            currCoor = round(currCoor);
            currCoor = num2cell(currCoor);
            if currCoor{1} <= size(spots,1) && currCoor{2} <= size(spots,2) && currCoor{3} <= size(spots,3) && currCoor{1} >= 1 && currCoor{2} >=1 && currCoor{3} >= 1 
                spots(currCoor{:}) = eachSpot;
            end
        else
            error('number of dimensions of L is not coded in this functino');
        end
    end
end


for eachCell = 1:maxCells
    currCell = L==eachCell;
    currSpots = imreconstruct(double(currCell),spots);
    currSpots = currSpots.*spots;
    currSpots = unique(currSpots(currSpots>0));
    if ~isempty(currSpots)
        spotParamsInL{eachCell} = spotParams(currSpots);
    end
end
