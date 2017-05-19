function [ benchStruct ] = procBenchMarkPSNR( benchStruct )
%PROCBENCHMARKPSNR calculates the PSNR for each condition


benchConditions = benchStruct.conditions;
psfs            = benchStruct.psfs;
Kmatrix         = benchStruct.Kmatrix;
psfObjs         = benchStruct.psfObjs;
numConditions = numel(benchConditions);
conditions    = cell(size(benchConditions));
psfSizes        = cellfunNonUniformOutput(@size,psfs);
PSNRmatrix     = zeros(size(conditions));
for ii = 1:numConditions
    display(['iteration ' num2str(ii) ' of ' num2str(numConditions)]);
    currConditions  = benchConditions{ii};
    bigTheta        = benchConditions{ii}.bigTheta;
    currFileList    = currConditions.fileList;
    currCamVarList  = currConditions.cameraVarList;
    
    currA           = currConditions.A;
    currB           = currConditions.B;
    currD           = currConditions.D;
    myIMMSEBasket    = cell(numel(currFileList),1);
    for jj = 1:numel(currFileList)
        display(['A:' num2str(currA) ' B:' num2str(currB) ' D:' num2str(currD) ' i:' num2str(jj) ' of ' num2str(numel(currFileList))]);
        currData = importStack(currFileList{jj});
        currCamVar = load(currCamVarList{jj});
        [~,currPhotons] = returnElectrons(currData,currCamVar.cameraParams);
        domains  = genMeshFromData(currData{1});
        [bigLambdas,~,~] = bigLambda(domains,bigTheta,'objKerns',psfObjs);
        currPhotons = cellfunNonUniformOutput(@(x,psfSizes) cropCenterSize(x,psfSizes),currPhotons(:),psfSizes(:));
        bigLambdas = cellfunNonUniformOutput(@(x,psfSizes) cropCenterSize(x,psfSizes),bigLambdas(:),psfSizes(:));
        currPhotons = cellfunNonUniformOutput(@(x) x(x>-inf),currPhotons);
        bigLambdas = cellfunNonUniformOutput(@(x) x(x>-inf),bigLambdas);
        myIMMSEBasket{jj} = cellfun(@(x,y) immse(x,y),currPhotons,bigLambdas);
        %-----APPY MY FUNC-------------------------------------------------
    end
    myMax = max(cellfun(@(x) max(x(:)),bigLambdas));
    myIMMSEBasket = cell2mat(myIMMSEBasket);
    myIMMSEBasket = myIMMSEBasket(:);
    myPSNR = (myMax^2)/mean(myIMMSEBasket);

    conditions{ii}.A                     = currA;
    conditions{ii}.B                     = currB;
    conditions{ii}.D                     = currD;
    conditions{ii}.PSNR                  = myPSNR;
    PSNRmatrix(ii) = myPSNR;
end

benchStruct.PSNR = conditions;

savePath = genProcessedFileName(benchConditions{1}.fileList{1}{1},@sum);
savePath = grabProcessedRest(savePath);
savePath = traversePath(savePath{1},1);
saveFile = [savePath filesep 'benchStruct'];
save(saveFile,'benchStruct');
display(['saving:' saveFile]);

end

