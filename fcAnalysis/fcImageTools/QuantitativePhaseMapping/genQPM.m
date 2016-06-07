function [qpm] = genQPM(stack)

% these parameters seem good for yeast
Nsl         = 50;
lambda      = 514e-9;
ps          = 6.5e-6 / 60;
dz          = 300e-9;

eps1 = 0.1;
eps2 = 0.1;
reflect = 0;
[~,~,zL] = size(stack);

nFocus = findBestFocus(stack);
display(['getQPM():best focus found at slice ' num2str(nFocus)]);



zSteps = 1:zL;
zSteps = zSteps - nFocus;
zSteps = zSteps * dz;

tic;
qpm = RunGaussionProcess(double(stack),nFocus,zSteps',lambda,ps,Nsl,eps1,eps2,reflect);
toc

se = strel('ball',100,100);
correctedQPM = imtophat(qpm,se);
% need to figure out rolling ball subtraction for matlba
% switch doBgkndSub
%     case 'rollingBall'
%         qpm = imtophat(qpm,strel('ball',diskR,diskR));
%     case 'polyFit'
%         rollingBalled = imtophat(qpm,strel('ball',diskR,100));
%         thresh = multithresh(rollingBalled);
%         mask = imquantize(rollingBalled,thresh);
%         [x,y] = size(qpm);
%         P = polyfitweighted2(1:y,1:x,qpm-mean(qpm(:)),3,mask==1);
%         estBackGround = polyval2(P,1:x,1:y);
%         qpm = qpm - estBackGround';
%     otherwise
% end
end




