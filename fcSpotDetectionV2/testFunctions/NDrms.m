function myRMS = NDrms(NDdata1,NDdata2)
%NDRMS returns ND root mean square error

myError = NDdata1(:) - NDdata2(:);
myRMS = sqrt(mean(myError.^2));


end

