function [qpm] = genQPM(stack)
startExp = 4;
        % these parameters seem good for yeast
        Nsl         = 50;%50;
        lambda      = 514e-9;
        ps          = 6.5e-6 / 60;%108.33e-9;%109e-9;%3.12e-7;
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


% subsample using exponential spacing so to cut down on computation time
% for the qpm
% if true
%     display('getQPMfromPhase():using exponential sampling');
%     % always take 10 around zFocus
%     upperHalf = nFocus:zL;
%     lowerHalf = fliplr(1:nFocus);
%     % after the 10 around zFocus start skipping 1,then 2, then 3, then to
%     % the end
%     if numel(upperHalf) > startExp
%         expSpacing = genExpSpacing(startExp,numel(upperHalf));
%         upperHalfExp = upperHalf(expSpacing);
%     end
%     % do the lower end
%     if numel(lowerHalf) > startExp
%         expSpacing = genExpSpacing(startExp,numel(lowerHalf));
%         lowerHalfExp = lowerHalf(expSpacing);
%     end
%     sampleExp = [fliplr(lowerHalfExp) upperHalfExp(2:end)];
%     nFocus = find(sampleExp == nFocus);
%     zSteps = zSteps(sampleExp);
%     stack = stack(:,:,sampleExp);
% end
% RePhase=RunGaussionProcess(Ividmeas,zfocus,z,lambda,ps,Nsl,eps1,eps2,reflect)
tic;
qpm = RunGaussionProcess(double(stack),nFocus,zSteps',lambda,ps,Nsl,eps1,eps2,reflect);
toc
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




