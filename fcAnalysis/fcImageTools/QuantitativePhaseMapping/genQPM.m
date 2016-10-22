function [correctedQPM] = genQPM(stack,varargin)
%GENQPM will take a brightfield zstack and convert it to a phase map
%
% stack:    your brightfield z stack


%--parameters--------------------------------------------------------------
params.ballSize      = 100;
params.nFocus        = [];
% to scale the small phase numbers
params.offset       = 10;
params.multiplier   = 1000000000;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

% these parameters seem good for yeast
Nsl         = 50;
lambda      = 514e-9;
ps          = 6.5e-6 / 60;
dz          = 300e-9;

eps1 = 0.1;
eps2 = 0.1;
reflect = 0;
[~,~,zL] = size(stack);

if isempty(params.nFocus)
    params.nFocus = findBestFocus(stack);
    display(['getQPM():best focus found at slice ' num2str(params.nFocus)]);
end
zSteps = 1:zL;
zSteps = zSteps - params.nFocus;
zSteps = zSteps * dz;

qpm = RunGaussionProcess(double(stack),params.nFocus,zSteps',lambda,ps,Nsl,eps1,eps2,reflect);
se = strel('ball',params.ballSize,params.ballSize);
% padd array by replciate
correctedQPM = padarray(qpm,[params.ballSize params.ballSize],'replicate');
correctedQPM = imtophat(params.multiplier*(correctedQPM+params.offset),se);
correctedQPM = uint16(unpadarray(correctedQPM,size(qpm)));
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




