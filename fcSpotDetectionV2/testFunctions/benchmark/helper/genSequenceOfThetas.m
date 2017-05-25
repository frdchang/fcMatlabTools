function [ seqTheta0 ] = genSequenceOfThetas( trueTheta0,estimated)
%genSequenceOfThetas will generate a sequence of initial theta0s to solve
%for the variance, first seq theta will be empty to let solver find MLE


Kmatrix = trueTheta0{1};
theRestOfThetas = trueTheta0(2:end);

% if thereis only 1 spot just return trueTheta0
if numSpotsInTheta(trueTheta0) <= 1
 seqTheta0 = cell(1+numel(theRestOfThetas),1);
    seqTheta0{1} = {};
    xyzcoor1 = trueTheta0{2}{1}{2}(2:end);
    cellxyz1 = num2cell(xyzcoor1);
    amp1 = estimated.A1{1}(cellxyz1{:});
    bkgnd1 = estimated.B1{1}(cellxyz1{:});
    obj1   = trueTheta0{2}{1}{1};
    seqTheta0{2} = ensureBkndThetasPos({Kmatrix, {{obj1,[amp1 xyzcoor1]},{bkgnd1}}});
    return;
end

if numSpotsInTheta(trueTheta0) == 2
    seqTheta0 = cell(1+numel(theRestOfThetas),1);
    seqTheta0{1} = {};
    xyzcoor1 = trueTheta0{2}{1}{2}(2:end);
    xyzcoor2 = trueTheta0{3}{1}{2}(2:end);
    cellxyz1 = num2cell(xyzcoor1);
    cellxyz2 = num2cell(xyzcoor2);
    amp1 = estimated.A1{1}(cellxyz1{:});
    amp2 = estimated.A1{2}(cellxyz2{:});
    bkgnd1 = estimated.B1{1}(cellxyz1{:});
    bkgnd2 = estimated.B1{2}(cellxyz2{:});
    obj1   = trueTheta0{2}{1}{1};
    obj2   = trueTheta0{3}{1}{1};
    
    b01   = estimated.B0{1}(cellxyz1{:});
    b02   = estimated.B0{2}(cellxyz2{:});
    if amp1 > amp2
        seqTheta0{2} = ensureBkndThetasPos({Kmatrix, {{obj1,[amp1 xyzcoor1]},{bkgnd1}}, {{b02}}});
    else
        seqTheta0{2} = ensureBkndThetasPos({Kmatrix, {{b01}}, {{obj2,[amp2 xyzcoor2]},{bkgnd2}}});
    end
    seqTheta0{3} = ensureBkndThetasPos({Kmatrix, {{obj1,[amp1 xyzcoor1]},{bkgnd1}}, {{obj2,[amp2 xyzcoor2]},{bkgnd2}}});
    return;
else
    error('num spots greater than 2, which i didnt code for');
end
