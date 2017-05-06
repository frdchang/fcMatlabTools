function [ bigThetas ] = genBigTheta(Kmatrix,psfs,thetas,domains)
%GENBIGTHETA will generate the theta input for bigLambda()
% if Kmatrix is multidimensional, then there is spectral bleedthru defined
% by this matrix.  psfs is a cell list of the different psfs for each
% channel and thetas is a cell list of the different thetas for each psfs
% and bkgnd.
%
% Kmatrix = [1 0.3;0.2 1];
% psfs    = {ndGauss([0.9,0.9,0.9],[7 7 7]),ndGauss([1.2,1.2,1.2],[7 7 7])};
% domains = genMeshFromData(ones(31,31,31));
% theta1  = {[10 3 3 3],[5 20 20 20],5};
% theta2  = {[6 10 10 10], 5};
% thetas  = {theta1,theta2};
% [ bigThetas ] = genBigTheta(Kmatrix,psfs,thetas,domains);





end

