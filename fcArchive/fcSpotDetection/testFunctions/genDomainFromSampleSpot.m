function domains = genDomainFromSampleSpot(sampleSpot)
%GENDOMAINFROMSAMPLESPOT will generate the meshgrid domains given
%sampleSpot.  
sizeData = size(sampleSpot.synAmp);
[x,y,z] = meshgrid(1:sizeData(1),1:sizeData(2),1:sizeData(3));
domains = {x,y,z};


end

