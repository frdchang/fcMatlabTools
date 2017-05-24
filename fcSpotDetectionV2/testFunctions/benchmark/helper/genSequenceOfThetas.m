function [ seqTheta0 ] = genSequenceOfThetas( trueTheta0,estimated)
%genSequenceOfThetas will generate a sequence of initial theta0s to solve
%for the variance, first seq theta will be empty to let solver find MLE


Kmatrix = trueTheta0{1};
theRestOfThetas = trueTheta0(2:end);


% if thereis only 1 spot just return trueTheta0
if numSpotsInTheta(trueTheta0) <= 1
    seqTheta0 = {{},trueTheta0};
    return;
end

if numSpotsInTheta(trueTheta0) == 2
    seqTheta0 = cell(1+numel(theRestOfThetas),1);
    seqTheta0{1} = {};
    seqTheta0{2} = {Kmatrix,trueTheta0{2},{trueTheta0{3}{end}}};
    seqTheta0{3} = {Kmatrix,trueTheta0{2},trueTheta0{3}};
    return;
else
    error('num spots greater than 2, which i didnt code for');
end
