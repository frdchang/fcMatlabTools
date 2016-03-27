function logfilter = LOG3D(sigmasqVec,sizeVec)
%LOG3D will generate a 3d laplacian of a gaussian
%
% sigmasqVec:       vector of sigma squares along each dimension
% sizeVec:          number of elements along each dimension

sigmasqVec = num2cell(sigmasqVec);
sizeVec = num2cell(sizeVec);
[sigmaXsq,sigmaYsq,sigmaZsq] = sigmasqVec{:};
[sizeX,sizeY,sizeZ] = sizeVec{:};
hX = sizeX/2;
hY = sizeY/2;
hZ = sizeZ/2;
[x,y,z] = meshgrid(-floor(hX):floor(hX),-floor(hY):floor(hY),-floor(hZ):floor(hZ));

logfilter = exp(1).^((1/2).*((-1).*sigmaXsq.^(-1).*x.^2+(-1).*sigmaYsq.^(-1).* ...
  y.^2+(-1).*sigmaZsq.^(-1).*z.^2)).*sigmaXsq.^(-2).*sigmaYsq.^(-2) ...
  .*sigmaZsq.^(-2).*(sigmaZsq.*(sigmaYsq.*((-1).*sigmaXsq.*( ...
  sigmaYsq.*sigmaZsq+sigmaXsq.*(sigmaYsq+sigmaZsq))+sigmaYsq.* ...
  sigmaZsq.*x.^2)+sigmaXsq.^2.*sigmaZsq.*y.^2)+sigmaXsq.^2.* ...
  sigmaYsq.^2.*z.^2);

logfilter = logfilter / sum(logfilter(:));
end

