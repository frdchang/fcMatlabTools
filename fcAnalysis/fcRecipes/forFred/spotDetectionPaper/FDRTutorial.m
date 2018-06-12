saveFolder = '~/Desktop/fcDataStorage/';
N = 100;
benchStruct = genBenchMark('benchType',1,'numSamples',N,'dist2Spots',0,'saveFolder',saveFolder,'As',[10],'Bs',[16]);
benchStruct = procBenchMarkStageI(benchStruct,@findSpotsStage1V2);
% benchStruct = procBenchMarkStageI(benchStruct,@logConv);
 benchStruct = procBenchMarkStageI(benchStruct,@regularConv);
% benchStruct = procBenchMarkStageI(benchStruct,@testTemplateMatching);
% benchStruct = procBenchMarkStageI(benchStruct,@gammaCorrection);


 analyzeStageIFPRPlot(benchStruct,@findSpotsStage1V2,'LLRatio');
% analyzeStageIFPR(benchStruct,@findSpotsStage1V2,'A1');
% analyzeStageIFPR(benchStruct,@logConv,'logConv');
% analyzeStageIFPR(benchStruct,@testTemplateMatching,'testTemplateMatching');
analyzeStageIFPRPlot(benchStruct,@regularConv,'regularConv');
% analyzeStageIFPR(benchStruct,@gammaCorrection,'negLoggammaSig');
%% this is the final version
close all;
sig = 0.05;
x = 0:0.1:10;
bA = 1;
bB = 2;
sA = 2;
sB = 2;
bkgnd = gampdf(x,bA,bB);
signal = gampdf(x,sA,sB);
cumBkgnd = gamcdf(x,bA,bB);
cumSig   = gamcdf(x,sA,sB);
idx = find(cumBkgnd > (1-sig),1);
eer = intersections(x,1-cumBkgnd,x,cumSig);

subplot_tight(4,1,1);
plot(x,bkgnd);hold on;plot(x,signal);axis tight;
vline(x(idx),'g',num2str(sig));
vline(eer,'r','EER');


subplot_tight(4,1,2);
plot(x,cumBkgnd); hold on; plot(x,cumSig); 
vline(x(idx),'g',num2str(sig));
vline(eer,'r','EER');

subplot_tight(4,1,3);
plot(x,1-cumBkgnd);hold on; plot(x,cumSig);legend('fpr','fnr');
vline(x(idx),'g',num2str(sig));
vline(eer,'r','EER');

subplot_tight(4,1,4);
plot(x,cumBkgnd);hold on; plot(x,1-cumSig);legend('tnr (selectivity)','tpr(sensitivity)');
vline(x(idx),'g',num2str(sig));
vline(eer,'r','EER');

%% generate different backgrounds to show background robustness
%% this is the final version
close all;
sig = 0.05;
x = 0:0.1:10;
bA = 1;
bB = 2;
sA = 2;
sB = 2;
bkgnd = gampdf(x,bA,bB);
signal = gampdf(x,sA,sB);
cumBkgnd = gamcdf(x,bA,bB);
cumSig   = gamcdf(x,sA,sB);
idx = find(cumBkgnd > (1-sig),1);
eer = intersections(x,1-cumBkgnd,x,cumSig);

subplot_tight(4,1,1);
plot(x,bkgnd);hold on;plot(x,signal);axis tight;
thisAxis = axis;
subplot_tight(4,1,2);
plot(x,gampdf(x,0.5,bB));hold on;plot(x,signal);axis tight;
axis(thisAxis);
subplot_tight(4,1,3);
plot(x,gampdf(x,0.25,bB));hold on;plot(x,signal);axis tight;
axis(thisAxis);
