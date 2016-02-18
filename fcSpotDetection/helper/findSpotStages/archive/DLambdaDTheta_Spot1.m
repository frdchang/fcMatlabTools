function DLambdaDTheta= DLambdaDTheta_Spot1(Amp,Bak,x0,y0,z0,sigXsq,sigYsq,sigZsq,x,y,z)
%DLAMBDADSPOT1 lambda(Amp*Gaussian(x0,y0,z0) + Bak) 
% theta = [amp,bak,x0,y0,z0]

heartFunc = exp(1).^((1/2).*((-1).*sigXsq.^(-1).*(x+(-1).*x0).^2+(-1).* ...
  sigYsq.^(-1).*(y+(-1).*y0).^2+(-1).*sigZsq.^(-1).*(z+(-1).*z0).^2));

DLambdaDTheta = cell(5,1);
DLambdaDTheta{1} = heartFunc;
DLambdaDTheta{2} = 1;
DLambdaDTheta{3} = Amp.*heartFunc.*sigXsq.^(-1).*(x+(-1).*x0);
DLambdaDTheta{4} = Amp.*heartFunc.*sigYsq.^(-1).*(y+(-1).*y0);
DLambdaDTheta{5} = Amp.*heartFunc.*sigZsq.^(-1).*(z+(-1).*z0);