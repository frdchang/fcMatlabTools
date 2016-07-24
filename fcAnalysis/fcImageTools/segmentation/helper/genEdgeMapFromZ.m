function edgeMap = genEdgeMapFromZ(brightfieldStack,edgeZProfile)
%GENEDGEMAPFROMZ generates an edge map from the z stack edge zprofile,
%which has a characteristic shape.  you basically take the pearson
%correlation to find the edge.
%
% edgeZProfile = [16962 17033 17319 17392 18426 21676 23678 24500 24320]
%


edgeMap = zeros(size(maxintensityproj(brightfieldStack,3)));

xSize = size(edgeMap,2);
ySize = size(edgeMap,1);
edgeZProfile = edgeZProfile(:);
edgeZProfile = edgeZProfile - mean(edgeZProfile);
edgeNorm = norm(edgeZProfile);
edgeZProfile = edgeZProfile / edgeNorm;
for ii = 1:xSize
    for jj=1:ySize
       zprofile = brightfieldStack(ii,jj,:);
       zprofile = zprofile(:);
       zprofile = zprofile - mean(zprofile);
       zprofileNorm = norm(zprofile);
       zprofile = zprofile / zprofileNorm;
       edgeMap(ii,jj) = sum(zprofile.*edgeZProfile);
    end
end

