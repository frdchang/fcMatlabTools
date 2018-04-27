%% i want to check if i can take the average scmos noise and calcualte expected fisher
doPlotEveryN   = inf;
params.DLLDLambda = @DLLDLambda_PoissPoiss;

params.sizeData         = [29 29 11];%[21 21 9];

params.psfFunc          = @genPSF;
params.binning          = 3;
params.psfFuncArgs      = {{'lambda',514e-9,'f',params.binning,'mode',0},{'lambda',610e-9,'f',params.binning,'mode',0}};
params.interpMethod     = 'linear';
params.kMatrix          = [1 0.9144; 0 1];

params.threshPSFArgs    = {[11,11,11]};
params.NoiseFunc        = @genSCMOSNoiseVar;
params.NoiseFuncArgs    = {params.sizeData,'scanType','slow'};

params.numSamples       = 1000;
params.As1              = 15;
params.As2              = 30;
params.Bs               = 6;
params.dist2Spots       = 6;

params.NoiseFuncArgs{1} = params.sizeData;
params.centerCoor       = round(params.sizeData/2);
centerCoor              = params.centerCoor;
Kmatrix                 = params.kMatrix;


% psfs        = cellfunNonUniformOutput(@(x) params.psfFunc(x{:}),params.psfFuncArgs);
% psfs        = cellfunNonUniformOutput(@(x) centerGenPSF(x),psfs);
% psfObjs     = cellfunNonUniformOutput(@(x) myPattern_Numeric(x,'downSample',[params.binning,params.binning,params.binning],'interpMethod',params.interpMethod),psfs);

sigmaSQ = [1 1 1];
patchSize = [17 17 17];
psfObjs     = {genGaussKernObj(sigmaSQ,patchSize),genGaussKernObj(sigmaSQ,patchSize)};
psfs        = cellfunNonUniformOutput(@(x) x.returnShape,psfObjs);
psfs        = cellfunNonUniformOutput(@(x) threshPSF(x,params.threshPSFArgs{:}),psfs);


% setup spot
domains     = genMeshFromData(zeros(params.sizeData));
secondCoor = centerCoor+[params.dist2Spots 0 0];
spotCoors = {{[params.As1 centerCoor],params.Bs},{[params.As2 secondCoor],params.Bs}};
bigTheta    = genBigTheta(Kmatrix,psfObjs,spotCoors);
% gen spot
[bigLambdas,bigDLambdas,d2]  = bigLambda(domains,bigTheta,'objKerns',psfObjs);
numSpots        = numSpotsInTheta(bigTheta);

MLEs = cell(params.numSamples,1);
sizeKern        = getPatchSize(psfs{1});

setupParForProgress(params.numSamples);
stds = cell(params.numSamples,1);
parfor ii = 1:params.numSamples
    incrementParForProgress();
    camVar = params.NoiseFunc(params.NoiseFuncArgs{:});
   [ infoMatrix,asymtotVar,stdErrors,fullInfoMatrix] = calcExpectedFisherInfo(bigLambdas,bigDLambdas,{camVar,camVar});
   stds{ii} = stdErrors;
end

% got the slow scan noise data
sampleSize = 209715200;
slowScanEdges =[0.54 0.57 0.6 0.63 0.66 0.69 0.72 0.75 0.78 0.81 0.84 0.87 0.9 0.93 0.96 0.99 1.02 1.05 1.08 1.11 1.14 1.17 1.2 1.23 1.26 1.29 1.32 1.35 1.38 1.41 1.44 1.47 1.5 1.53 1.56 1.59 1.62 1.65 1.68 1.71 1.74 1.77 1.8 1.83 1.86 1.89 1.92 1.95 1.98 2.01 2.04 2.07 2.1 2.13 2.16 2.19 2.22 2.25 2.28 2.31 2.34 2.37 2.4 2.43 2.46 2.49 2.52 2.55 2.58 2.61 2.64 2.67 2.7 2.73 2.76 2.79 2.82 2.85 2.88 2.91 2.94 2.97 3 3.03 3.06 3.09 3.12 3.15 3.18 3.21 3.24 3.27 3.3 3.33 3.36 3.39 3.42 3.45 3.48 3.51 3.54 3.57 3.6 3.63 3.66 3.69 3.72 3.75 3.78 3.81 3.84 3.87 3.9 3.93 3.96 3.99 4.02 4.05 4.08 4.11 4.14 4.17 4.2 4.23 4.26 4.29 4.32 4.35 4.38 4.41 4.44 4.47 4.5 4.53 4.56 4.59 4.62 4.65 4.68 4.71 4.74 4.77 4.8 4.83 4.86 4.89 4.92 4.95 4.98 5.01 5.04 5.07 5.1 5.13 5.16 5.19 5.22 5.25 5.28 5.31 5.34 5.37 5.4 5.43 5.46 5.49 5.52 5.55 5.58 5.61 5.64 5.67 5.7 5.73 5.76 5.79 5.82 5.85 5.88 5.91 5.94 5.97 6 6.03 6.06 6.09 6.12 6.15 6.18 6.21 6.24 6.27 6.3 6.33 6.36 6.39 6.42 6.45 6.48 6.51 6.54 6.57 6.6 6.63 6.66 6.69 6.72 6.75 6.78 6.81 6.84 6.87 6.9 6.93 6.96 6.99 7.02 7.05 7.08 7.11 7.14 7.17 7.2 7.23 7.26 7.29 7.32 7.35 7.38 7.41 7.44 7.47 7.5 7.53 7.56 7.59 7.62 7.65 7.68 7.71 7.74 7.77 7.8 7.83 7.86 7.89 7.92 7.95 7.98 8.01 8.04 8.07 8.1 8.13 8.16 8.19 8.22 8.25 8.28 8.31 8.34 8.37 8.4 8.43 8.46 8.49 8.52 8.55 8.58 8.61 8.64 8.67 8.7 8.73 8.76 8.79 8.82 8.85 8.88 8.91 8.94 8.97 9 9.03 9.06 9.09 9.12 9.15 9.18 9.21 9.24 9.27 9.3 9.33 9.36 9.39 9.42 9.45 9.48 9.51 9.54 9.57 9.6 9.63 9.66 9.69 9.72 9.75 9.78 9.81 9.84 9.87 9.9 9.93 9.96 9.99 10.02 10.05 10.08 10.11 10.14 10.17 10.2 10.23 10.26 10.29 10.32 10.35 10.38 10.41 10.44 10.47 10.5 10.53 10.56 10.59 10.62 10.65 10.68 10.71 10.74 10.77 10.8 10.83 10.86 10.89 10.92 10.95 10.98 11.01 11.04 11.07 11.1 11.13 11.16 11.19 11.22 11.25 11.28 11.31 11.34 11.37 11.4 11.43 11.46 11.49 11.52 11.55 11.58 11.61 11.64 11.67 11.7 11.73 11.76 11.79 11.82 11.85 11.88 11.91 11.94 11.97 12 12.03 12.06 12.09 12.12 12.15 12.18 12.21 12.24 12.27 12.3 12.33 12.36 12.39 12.42 12.45 12.48 12.51 12.54 12.57 12.6 12.63 12.66 12.69 12.72 12.75 12.78 12.81 12.84 12.87 12.9 12.93 12.96 12.99 13.02 13.05 13.08 13.11 13.14 13.17 13.2 13.23 13.26 13.29 13.32 13.35 13.38 13.41 13.44 13.47 13.5 13.53 13.56 13.59 13.62 13.65 13.68 13.71 13.74 13.77 13.8 13.83 13.86 13.89 13.92 13.95 13.98 14.01 14.04 14.07 14.1 14.13 14.16 14.19 14.22 14.25 14.28 14.31 14.34 14.37 14.4 14.43 14.46 14.49 14.52 14.55 14.58 14.61 14.64 14.67 14.7 14.73 14.76 14.79 14.82 14.85 14.88 14.91 14.94 14.97 15 15.03 15.06 15.09 15.12 15.15 15.18 15.21 15.24 15.27 15.3 15.33 15.36 15.39 15.42 15.45 15.48 15.51 15.54 15.57 15.6 15.63 15.66 15.69 15.72 15.75 15.78 15.81 15.84 15.87 15.9 15.93 15.96 15.99 16.02 16.05 16.08 16.11 16.14 16.17 16.2 16.23 16.26 16.29 16.32 16.35 16.38 16.41 16.44 16.47 16.5 16.53 16.56 16.59 16.62 16.65 16.68 16.71 16.74 16.77 16.8 16.83 16.86 16.89 16.92 16.95 16.98 17.01 17.04 17.07 17.1 17.13 17.16 17.19 17.22 17.25 17.28 17.31 17.34 17.37 17.4 17.43 17.46 17.49 17.52 17.55 17.58 17.61 17.64 17.67 17.7 17.73 17.76 17.79 17.82 17.85 17.88 17.91 17.94 17.97 18 18.03 18.06 18.09 18.12 18.15 18.18 18.21 18.24 18.27 18.3 18.33 18.36 18.39 18.42 18.45 18.48 18.51 18.54 18.57 18.6 18.63 18.66 18.69 18.72 18.75 18.78 18.81 18.84 18.87 18.9 18.93 18.96 18.99 19.02 19.05 19.08 19.11 19.14 19.17 19.2 19.23 19.26 19.29 19.32 19.35 19.38 19.41 19.44 19.47 19.5 19.53 19.56 19.59 19.62 19.65 19.68 19.71 19.74 19.77 19.8 19.83 19.86 19.89 19.92 19.95 19.98 20.01 20.04 20.07 20.1 20.13 20.16 20.19 20.22 20.25 20.28 20.31 20.34 20.37 20.4 20.43 20.46 20.49 20.52 20.55 20.58 20.61 20.64 20.67 20.7 20.73 20.76 20.79 20.82 20.85 20.88 20.91 20.94 20.97 21];
slowScanVals =[0.000127156575520833 0.00565846761067708 0.120894114176433 0.626722971598307 1.2427012125651 1.98974609375001 3.05636723836263 3.61483891805013 3.23162078857422 2.52660115559896 2.07773844401042 1.71957015991211 1.37691497802734 1.09939575195313 0.862439473470051 0.719070434570312 0.605996449788411 0.519212086995442 0.454711914062503 0.406106313069658 0.365320841471357 0.336106618245442 0.310325622558593 0.279076894124349 0.251197814941406 0.234317779541015 0.205930074055989 0.18752415974935 0.17722447713216 0.162410736083985 0.146897633870443 0.136057535807292 0.131575266520182 0.119495391845703 0.116062164306641 0.108464558919271 0.103473663330079 0.0955899556477864 0.0924110412597655 0.0887870788574218 0.0831286112467447 0.0801086425781249 0.0801722208658854 0.0775655110677088 0.0738779703776041 0.0694910685221354 0.0686963399251301 0.0643412272135416 0.0609397888183598 0.0613530476888016 0.0594139099121089 0.0555674235026045 0.0554084777832035 0.0525474548339839 0.0508944193522139 0.0514984130859378 0.0494321187337236 0.0494639078776038 0.046189626057943 0.0435829162597659 0.0448226928710934 0.0436464945475263 0.0421206156412763 0.0422159830729163 0.0405629475911455 0.0389099121093753 0.0375111897786461 0.0367800394694007 0.0358581542968752 0.0335057576497393 0.0341733296712242 0.0344276428222653 0.0337282816569013 0.0323295593261721 0.0325838724772133 0.0291506449381512 0.0306447347005206 0.0315348307291669 0.0303586324055987 0.0281651814778648 0.0269889831542971 0.0259081522623696 0.0275611877441408 0.0282287597656248 0.0246047973632814 0.0252723693847654 0.0238418579101564 0.0227292378743491 0.0229517618815102 0.0228563944498699 0.0231742858886717 0.0232696533203127 0.0217437744140623 0.0205993652343751 0.0193913777669269 0.0207901000976564 0.0188509623209637 0.0192324320475259 0.0182151794433595 0.0177701314290363 0.0184059143066407 0.0171661376953124 0.017070770263672 0.0176111857096353 0.0156084696451824 0.0157992045084636 0.0169754028320311 0.0157992045084636 0.0152905782063801 0.0161806742350261 0.0163396199544269 0.0145912170410157 0.0153859456380209 0.0146547953287759 0.0150680541992188 0.0145276387532553 0.0124295552571614 0.0132560729980468 0.0134150187174482 0.0120162963867187 0.0137011210123697 0.0105857849121096 0.0136375427246089 0.0111897786458336 0.0122070312499999 0.0112533569335937 0.0115394592285159 0.0116030375162759 0.0114123026529947 0.0106811523437502 0.0109672546386718 0.0102678934733072 0.0100771586100263 0.00934600830078117 0.0102043151855468 0.00861485799153639 0.0095367431640627 0.00858306884765618 0.00918706258138013 0.00921885172526034 0.00855127970377622 0.0094413757324218 0.00915527343749992 0.00785191853841139 0.00839233398437518 0.00715255737304682 0.00864664713541659 0.00759760538736995 0.00743865966796869 0.00718434651692702 0.00686645507812494 0.00769297281901058 0.00794728597005202 0.00734329223632806 0.00613530476888034 0.0067075093587239 0.00578562418619787 0.00635782877604161 0.00689824422200536 0.00594456990559891 0.00588099161783849 0.00616709391276055 0.00540415445963537 0.00667572021484369 0.00578562418619787 0.00549952189127616 0.00537236531575516 0.00588099161783849 0.00546773274739595 0.00584920247395828 0.00572204589843745 0.00575383504231766 0.00480016072591156 0.005499521891276 0.00451405843098955 0.00483194986979177 0.00454584757486975 0.0055313110351562 0.00400543212890622 0.00445048014322926 0.0039418538411458 0.00457763671874996 0.00403722127278643 0.00416437784830738 0.00381469726562497 0.00381469726562497 0.0035285949707032 0.00349680582682289 0.00336964925130206 0.0035285949707031 0.00486373901367198 0.00336964925130206 0.0031471252441406 0.00330607096354174 0.00324249267578122 0.00362396240234372 0.00336964925130206 0.00311533610026048 0.00254313151041665 0.0027656555175781 0.00324249267578132 0.00311533610026039 0.00267028808593748 0.0027656555175781 0.00273386637369798 0.00305175781249997 0.00254313151041665 0.00270207722981769 0.00219345092773442 0.00216166178385415 0.00212987263997394 0.00257492065429693 0.00244776407877602 0.00267028808593748 0.00209808349609373 0.00187555948893233 0.00219345092773436 0.00241597493489581 0.00267028808593756 0.00219345092773436 0.00219345092773436 0.00165303548177082 0.002129872639974 0.00209808349609373 0.00203450520833332 0.00184377034505212 0.00187555948893228 0.00184377034505207 0.00152587890624999 0.00155766805013024 0.00241597493489581 0.00130335489908853 0.00133514404296878 0.00152587890624999 0.00187555948893228 0.00219345092773436 0.00123977661132815 0.0015576680501302 0.00178019205729165 0.0013987223307292 0.00178019205729165 0.00171661376953124 0.00187555948893228 0.00152587890625003 0.00146230061848957 0.00130335489908853 0.00127156575520832 0.00120798746744794 0.00178019205729165 0.00114440917968752 0.00120798746744787 0.000985463460286479 0.00117619832356773 0.00117619832356766 0.00146230061848961 0.00123977661132815 0.000985463460286421 0.00136693318684899 0.00120798746744794 0.00108083089192704 0.00139872233072911 0.000953674316406327 0.00104904174804684 0.000794728597005178 0.00111262003580738 0.000858306884765592 0.0008900960286458 0.00130335489908865 0.000858306884765592 0.00101725260416663 0.00069936116536464 0.000540415445963521 0.000826517740885385 0.000762939453125061 0.0008900960286458 0.000921885172526007 0.000731150309244764 0.000890096028645905 0.000635782877604143 0.000762939453124971 0.000858306884765694 0.000540415445963521 0.000826517740885385 0.000921885172526116 0.0004450480143229 0.000953674316406214 0.000858306884765694 0.000317891438802071 0.000476837158203107 0.000890096028645905 0.00066757202148435 0.000476837158203107 0.000476837158203163 0.000603993733723935 0.000572204589843728 0.000540415445963585 0.000635782877604143 0.000476837158203107 0.000794728597005272 0.000603993733723935 0.000508626302083314 0.000476837158203107 0.00034968058268232 0.000699361165364557 0.000699361165364557 0.000381469726562531 0.000317891438802071 0.000381469726562486 0.000667572021484429 0.000349680582682278 0.000508626302083314 0.000413258870442742 0.000349680582682278 0.000572204589843728 0.000413258870442742 0.000349680582682278 0.000413258870442693 0.000413258870442742 0.000349680582682278 0.000381469726562486 0.000445048014322953 0.000286102294921864 0.000286102294921864 0.000540415445963585 0.000127156575520829 0.000476837158203107 0.00022252400716145 0.000286102294921898 0.000349680582682278 0.000254313151041657 0.000254313151041687 0.000190734863281243 0.000190734863281243 0.000381469726562531 0.000317891438802071 0.000317891438802071 0.000222524007161476 0.000413258870442693 0.000349680582682278 0.000286102294921898 0.000127156575520829 0.000190734863281243 0.000317891438802109 0.000158945719401036 0.00022252400716145 0.000413258870442742 0.000254313151041657 0.000190734863281243 0.000286102294921898 0.000381469726562486 0.000190734863281243 0.000127156575520844 0.000317891438802071 0.000127156575520829 0.00022252400716145 0.000413258870442742 0.000127156575520829 0.000286102294921864 9.53674316406327e-05 0.000317891438802071 0.000254313151041657 0.000286102294921898 0.000190734863281243 0.000254313151041657 0.000222524007161476 0.000190734863281243 0.000254313151041657 0.000190734863281265 0.000286102294921864 0.000286102294921864 0.000158945719401054 0.000190734863281243 0.000190734863281243 0.000158945719401054 0.000190734863281243 3.17891438802071e-05 0.000158945719401054 9.53674316406214e-05 0.000317891438802071 6.35782877604143e-05 0.000254313151041687 0.00022252400716145 0.000127156575520829 0.000381469726562531 0.000158945719401036 0.000254313151041657 0.000190734863281265 0.000127156575520829 9.53674316406214e-05 3.17891438802109e-05 0.00022252400716145 9.53674316406214e-05 9.53674316406327e-05 0.000158945719401036 9.53674316406214e-05 6.35782877604218e-05 9.53674316406214e-05 0.000127156575520829 0.000127156575520844 0.000158945719401036 0.000127156575520829 0.000254313151041687 0.000127156575520829 9.53674316406214e-05 6.35782877604143e-05 0.000190734863281265 9.53674316406214e-05 0.000190734863281243 9.53674316406327e-05 3.17891438802071e-05 6.35782877604143e-05 0.000127156575520844 0.000190734863281243 6.35782877604143e-05 9.53674316406327e-05 3.17891438802071e-05 0.000127156575520829 6.35782877604218e-05 3.17891438802071e-05 3.17891438802071e-05 3.17891438802109e-05 0 3.17891438802071e-05 0.000190734863281265 9.53674316406214e-05 9.53674316406214e-05 3.17891438802109e-05 0 9.53674316406214e-05 3.17891438802071e-05 6.35782877604218e-05 9.53674316406214e-05 0 6.35782877604218e-05 0 6.35782877604143e-05 6.35782877604218e-05 3.17891438802071e-05 0.000190734863281243 6.35782877604218e-05 3.17891438802071e-05 9.53674316406214e-05 0 0 9.53674316406214e-05 6.35782877604218e-05 6.35782877604143e-05 0 0 3.17891438802071e-05 6.35782877604143e-05 6.35782877604218e-05 3.17891438802071e-05 3.17891438802071e-05 0 3.17891438802109e-05 3.17891438802071e-05 6.35782877604143e-05 3.17891438802109e-05 6.35782877604143e-05 6.35782877604143e-05 9.53674316406327e-05 9.53674316406214e-05 6.35782877604143e-05 9.53674316406327e-05 3.17891438802071e-05 0 3.17891438802109e-05 3.17891438802071e-05 3.17891438802071e-05 6.35782877604218e-05 3.17891438802071e-05 3.17891438802071e-05 3.17891438802109e-05 3.17891438802071e-05 0 9.53674316406327e-05 0 0 3.17891438802109e-05 3.17891438802071e-05 3.17891438802071e-05 3.17891438802071e-05 3.17891438802109e-05 9.53674316406214e-05 9.53674316406214e-05 0 3.17891438802071e-05 3.17891438802071e-05 0 0 3.17891438802071e-05 6.35782877604218e-05 6.35782877604143e-05 0 0 0 3.17891438802071e-05 6.35782877604218e-05 6.35782877604143e-05 3.17891438802071e-05 3.17891438802109e-05 3.17891438802071e-05 3.17891438802071e-05 0 3.17891438802071e-05 0 6.35782877604143e-05 6.35782877604218e-05 3.17891438802071e-05 0 6.35782877604218e-05 0 0 6.35782877604218e-05 3.17891438802071e-05 0 0 3.17891438802071e-05 3.17891438802071e-05 0 0 0 0 0 0 6.35782877604218e-05 3.17891438802071e-05 0 9.53674316406327e-05 0 0 6.35782877604143e-05 0 0 0 3.17891438802071e-05 0 0 0 0 6.35782877604218e-05 0 0 0 0 0 3.17891438802109e-05 3.17891438802071e-05 3.17891438802071e-05 0 0 3.17891438802071e-05 0 0 3.17891438802071e-05 6.35782877604143e-05 3.17891438802109e-05 0 3.17891438802071e-05 0 6.35782877604143e-05 3.17891438802071e-05 0 3.17891438802071e-05 0 0 0 3.17891438802071e-05 0 0 0 3.17891438802109e-05 0 0 3.17891438802071e-05 0 0 0 0 0 0 3.17891438802109e-05 0 0 3.17891438802109e-05 3.17891438802071e-05 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3.17891438802071e-05 6.35782877604218e-05 0 0 0 0 0 0 0 3.17891438802071e-05 0 0 0 3.17891438802109e-05 0 3.17891438802071e-05 0 0 0 3.17891438802109e-05 0 0 0 0 0 0 0 0 3.17891438802071e-05 0 0 0 0 0 0 0 0 0 0 0 0 3.17891438802109e-05 0 0 0 3.17891438802071e-05 0 0 0 0 0 0 0 0 3.17891438802109e-05 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3.17891438802071e-05];

scmosNoise= sampleFromEmpiricalDistribution(slowScanVals,slowScanEdges,sampleSize);
meanVar = mean(scmosNoise.^2);

[ ~,~,stdErrorsTheory,~] = calcExpectedFisherInfo(bigLambdas,bigDLambdas,{meanVar*ones(size(camVar)),meanVar*ones(size(camVar))});

%compare this to measured
measured = mean(stds,1);

% measured is slightly higher since there is also the effects of broken
% pixels i am simulating that is not captured by simply taking the mean of
% the variance histogram.  hmm...

% what if i simulate the loss of pixels by higher camera variance?

tryThisVar = meanVar + linspace(-2,2,1000);
error = zeros(numel(tryThisVar),1);
parfor ii = 1:numel(tryThisVar)
    [ ~,~,stdErrorsTheory,~] = calcExpectedFisherInfo(bigLambdas,bigDLambdas,{tryThisVar(ii)*ones(size(camVar)),tryThisVar(ii)*ones(size(camVar))});
    error(ii) =corr(measured(:),stdErrorsTheory(:));
end
plot(tryThisVar,error);
idx = find(max(error)==error);
useThisVar = tryThisVar(idx);
% this variance gives a best fit   2.5919 for slow scan scmos and its
% broken pixel rate.  
% use this to generate a theoretical camera roa or std error landscape
% 
% 
%% check cramer roa lower bound
doPlotEveryN   = inf;
params.DLLDLambda = @DLLDLambda_PoissPoiss;

params.sizeData         = [29 29 11];%[21 21 9];

params.psfFunc          = @genPSF;
params.binning          = 3;
params.psfFuncArgs      = {{'lambda',514e-9,'f',params.binning,'mode',0},{'lambda',610e-9,'f',params.binning,'mode',0}};
params.interpMethod     = 'linear';
params.kMatrix          = [1 0.9144; 0 1];

params.threshPSFArgs    = {[11,11,11]};
params.NoiseFunc        = @genSCMOSNoiseVar;
params.NoiseFuncArgs    = {params.sizeData,'scanType','slow'};

params.numSamples       = 100;
params.As1              = 15;
params.As2              = 30;
params.Bs               = 6;
params.dist2Spots       = 6;

params.NoiseFuncArgs{1} = params.sizeData;
params.centerCoor       = round(params.sizeData/2);
centerCoor              = params.centerCoor;
Kmatrix                 = params.kMatrix;


% psfs        = cellfunNonUniformOutput(@(x) params.psfFunc(x{:}),params.psfFuncArgs);
% psfs        = cellfunNonUniformOutput(@(x) centerGenPSF(x),psfs);
% psfObjs     = cellfunNonUniformOutput(@(x) myPattern_Numeric(x,'downSample',[params.binning,params.binning,params.binning],'interpMethod',params.interpMethod),psfs);

sigmaSQ = [1 1 1];
patchSize = [17 17 17];
psfObjs     = {genGaussKernObj(sigmaSQ,patchSize),genGaussKernObj(sigmaSQ,patchSize)};
psfs        = cellfunNonUniformOutput(@(x) x.returnShape,psfObjs);
psfs        = cellfunNonUniformOutput(@(x) threshPSF(x,params.threshPSFArgs{:}),psfs);


% setup spot
domains     = genMeshFromData(zeros(params.sizeData));
secondCoor = centerCoor+[params.dist2Spots 0 0];
spotCoors = {{[params.As1 centerCoor],params.Bs},{[params.As2 secondCoor],params.Bs}};
bigTheta    = genBigTheta(Kmatrix,psfObjs,spotCoors);
% gen spot
[bigLambdas,bigDLambdas,d2]  = bigLambda(domains,bigTheta,'objKerns',psfObjs);
numSpots        = numSpotsInTheta(bigTheta);

MLEs = cell(params.numSamples,1);
sizeKern        = getPatchSize(psfs{1});

 camVar                       = params.NoiseFunc(params.NoiseFuncArgs{:});
 [stack,~,cameraParams]       = genMicroscopeNoise(bigLambdas,'readNoiseData',camVar);
cameraVarianceInElectrons   = cameraParams.cameraVarianceInADU.*(cameraParams.gainElectronPerCount.^2);
    
setupParForProgress(params.numSamples);
parfor ii = 1:params.numSamples
    incrementParForProgress();
    [stack,~,cameraParams]       = genMicroscopeNoise(bigLambdas,'readNoiseData',camVar);
    [~,photonData]              = returnElectrons(stack,cameraParams);
    estimated                   = findSpotsStage1V2(photonData,psfs,cameraVarianceInElectrons,'kMatrix',Kmatrix);
    myTheta0s                   = genSequenceOfThetas(bigTheta,estimated);
    % define candidates
    L = zeros(size(stack{1}));
    spotCoors = getSpotCoorsFromTheta(bigTheta);
    for zz = 1:numel(spotCoors)
        cellCoor = num2cell(spotCoors{zz});
        L(cellCoor{:}) = 1;
    end
    
    
    L = imdilate(L,strel(ones(sizeKern(:)')));
    L = bwlabeln(L>0);
    stats = regionprops(L,'PixelList','SubarrayIdx','PixelIdxList');
    
    currMask = L == 1;
    carvedDatas                 = carveOutWithMask(photonData,currMask,[0,0,0]);
    carvedEstimates             = carveOutWithMask(estimated,currMask,[0,0,0],'spotKern','convFunc');
    carvedCamVar                = carveOutWithMask(cameraVarianceInElectrons,currMask,[0,0,0]);
    carvedMask                  = carveOutWithMask(currMask,currMask,[0,0,0]);
    carvedRectSubArrayIdx       = stats(1).SubarrayIdx;
    carvedEstimates.spotKern    = estimated.spotKern;
    %-----APPY MY FUNC-------------------------------------------------
    MLEs{ii}                 = doMultiEmitterFitting(carvedMask,carvedRectSubArrayIdx,carvedDatas,carvedEstimates,carvedCamVar,Kmatrix,psfObjs,'theta0',myTheta0s,'numSpots',numSpots,'doPlotEveryN',doPlotEveryN,'DLLDLambda',params.DLLDLambda);
end

% define cramer rao bound, need to carve out big lambdas and such 
        bigLambdas = cellfunNonUniformOutput(@(x) x(currMask),bigLambdas);
        
        for kk = 1:numel(bigDLambdas)
            if ~isscalar(bigDLambdas{kk})
                bigDLambdas{kk} = bigDLambdas{kk}(currMask);
            end
        end
        
        carvedsigmasqs = cellfunNonUniformOutput(@(x) x(currMask),{cameraVarianceInElectrons,cameraVarianceInElectrons});

[ infoMatrix,asymtotVar,stdErrors,fullInfoMatrix] = calcExpectedFisherInfo(bigLambdas,bigDLambdas,carvedsigmasqs);
observedFisherInfo = extractCellStructField(MLEs,3,'thetaStdErrors');
observedFisherInfo = removeEmptyCells(observedFisherInfo);
observedFisherInfo = cell2mat(observedFisherInfo');

thetas = extractCellStructField(MLEs,3,'thetaMLEs');
thetas = removeEmptyCells(thetas);
thetas = cellfunNonUniformOutput(@(x) flattenTheta0s(x),thetas);
thetas = cellfunNonUniformOutput(@(x) x(5:end),thetas);
thetas = cell2mat(thetas');

trueTheta = flattenTheta0s(bigTheta);
trueTheta = trueTheta(5:end);
createFullMaxFigure;
for ii = 1:numel(stdErrors)
   subplot_tight(2,5,ii);
   h = histogram(thetas(ii,:));title(['theta ' num2str(ii)]);
   h.Normalization = 'pdf';
    h.EdgeColor = 'none';
    setAxesByThresh(h,4);
   gaussDom = linspace(h.BinLimits(1),h.BinLimits(2),100);
   gauss = normpdf(gaussDom,trueTheta(ii),stdErrors(ii));
   hold on; plot(gaussDom,gauss);
end

createFullMaxFigure;
for ii = 1:numel(stdErrors)
    subplot_tight(2,5,ii);
    data =  deleteoutliers(observedFisherInfo(ii,:),0.05);
    h = histogram(data);title(['theta ' num2str(ii)]);
       h.Normalization = 'pdf';
        h.EdgeColor = 'none';
            setAxesByThresh(h,3);

    vline(stdErrors(ii),'r','expected fisher');
end
%% define an analytic 3d gaussian and compare to numeric
% analytic is 2 orders of magnitude faster and comparable to numeric

sizeData         = [29 29 11];
sigmaSq          = [0.9,0.9,0.9];
domains          = genMeshFromData(zeros(sizeData));
centerCoor       = getCenterCoor(sizeData);

% define analytic gaussian
gaussObj         = myPattern_3DGaussianConstSigmas(sigmaSq);
[D,D1,D2]        = gaussObj.givenThetaGetDerivatives(domains,centerCoor,[1 1 1]);
% define numeric gaussian

holder = zeros(10,1);
parfor binning = 1:10
    display(binning);
    sigmas           = sqrt(sigmaSq);
    kernBinning      = ndGauss((sigmas*binning).^2,sizeData*binning);
    kernBinning = kernBinning/max(kernBinning(:));
    numericObj       = myPattern_Numeric(kernBinning,'downSample',[binning,binning,binning],'interpMethod','neighbor');
    [Dn,D1n,D2n]        = numericObj.givenThetaGetDerivatives(domains,centerCoor,[1 1 1]);
    holder(binning) =  calcRMSE(D2{1},D2n{1});
end
plot(holder);
ylim([0 inf]);

% binning = 3 is optimal.  RMSE doesn't converge, but i think its because
% the ndgauss isn't growing as if you can downsample it back to a smaller
% one.  below is an example that works.


delta = 1:-0.1:0.1;
x1 = 0:10;
x2 = 0:0.01:10;
func = @(x) sin(x);
dfunc = @(x) cos(x);
y = func(x1);
dy = dfunc(x1);

ndy = gradient(y);
ndy2 = gradient(func(x2),0.01);
ndy3 = interpn(x2,ndy2,x1,'linear');
plot(x1,y,'--x');hold on;plot(x1,dy,'--x');
plot(x1,ndy,'-o');plot(x2,ndy2,'-');plot(x1,ndy3,'-s');

figure;
plot(x1,dy,'-x');hold on;plot(x1,ndy3,'--s');

% i think the difference lays in the fact that sigma does not scale
% correctly.  let me check this
sigmas = [2];
sizeData = [11];
N = 10;
for binning = 1:N
    kernBinning      = ndGauss((sigmas*binning).^2,sizeData*binning);
    down = interpn(linspace(1,sizeData,sizeData*binning),kernBinning,1:sizeData,'linear');
    hold on; plot(down);
end

% yup.  


%% check 2 spot performance at A = 15 B = 6
% -flip kmatrix in stage ii and see the results to see if its correct.
% i had to manually flip the kmatrix in between the parfor loops.  as
% expected, not taking advtange of correct kmatrix leads to large variance
% in the parameter. so the code seems ok from this persepctive. 
doPlotEveryN   = inf;
params.DLLDLambda = @DLLDLambda_PoissPoiss;

params.sizeData         = [29 29 11];%[21 21 9];

params.psfFunc          = @genPSF;
params.binning          = 3;
params.psfFuncArgs      = {{'lambda',514e-9,'f',params.binning,'mode',0},{'lambda',610e-9,'f',params.binning,'mode',0}};
params.interpMethod     = 'linear';
params.kMatrix          = [1 0.9144; 0 1];

params.threshPSFArgs    = {[11,11,11]};
params.NoiseFunc        = @genSCMOSNoiseVar;
params.NoiseFuncArgs    = {params.sizeData,'scanType','slow'};

params.numSamples       = 10;
params.As1               = 15;
params.As2               = 30;
params.Bs               = 6;
params.dist2Spots       = 6;

params.NoiseFuncArgs{1} = params.sizeData;
params.centerCoor       = round(params.sizeData/2);
centerCoor              = params.centerCoor;
Kmatrix                 = params.kMatrix;


% psfs        = cellfunNonUniformOutput(@(x) params.psfFunc(x{:}),params.psfFuncArgs);
% psfs        = cellfunNonUniformOutput(@(x) centerGenPSF(x),psfs);
% psfObjs     = cellfunNonUniformOutput(@(x) myPattern_Numeric(x,'downSample',[params.binning,params.binning,params.binning],'interpMethod',params.interpMethod),psfs);

sigmaSQ = [1 1 1];
patchSize = [16 16 16];
psfObjs     = {genGaussKernObj(sigmaSQ,patchSize),genGaussKernObj(sigmaSQ,patchSize)};
psfs        = cellfunNonUniformOutput(@(x) x.returnShape,psfObjs);
psfs        = cellfunNonUniformOutput(@(x) threshPSF(x,params.threshPSFArgs{:}),psfs);


% setup spot
domains     = genMeshFromData(zeros(params.sizeData));
secondCoor = centerCoor+[params.dist2Spots 0 0];
spotCoors = {{[params.As1 centerCoor],params.Bs},{[params.As2 secondCoor],params.Bs}};
bigTheta    = genBigTheta(Kmatrix,psfObjs,spotCoors);
% gen spot
[bigLambdas,d1,d2]  = bigLambda(domains,bigTheta,'objKerns',psfObjs);
numSpots        = numSpotsInTheta(bigTheta);

MLEs = cell(params.numSamples,1);
sizeKern        = size(psfs{1});

setupParForProgress(params.numSamples);
parfor ii = 1:params.numSamples
    incrementParForProgress();
    camVar                       = params.NoiseFunc(params.NoiseFuncArgs{:});
    [stack,~,cameraParams]       = genMicroscopeNoise(bigLambdas,'readNoiseData',camVar);
    cameraVarianceInElectrons   = cameraParams.cameraVarianceInADU.*(cameraParams.gainElectronPerCount.^2);
    [~,photonData]              = returnElectrons(stack,cameraParams);
    estimated                   = findSpotsStage1V2(photonData,psfs,cameraVarianceInElectrons,'kMatrix',Kmatrix);
    myTheta0s                   = genSequenceOfThetas(bigTheta,estimated);
    % define candidates
    L = zeros(size(stack{1}));
    spotCoors = getSpotCoorsFromTheta(bigTheta);
    for zz = 1:numel(spotCoors)
        cellCoor = num2cell(spotCoors{zz});
        L(cellCoor{:}) = 1;
    end
    
    
    L = imdilate(L,strel(ones(sizeKern(:)')));
    L = bwlabeln(L>0);
    stats = regionprops(L,'PixelList','SubarrayIdx','PixelIdxList');
    
    currMask = L == 1;
    carvedDatas                 = carveOutWithMask(photonData,currMask,[0,0,0]);
    carvedEstimates             = carveOutWithMask(estimated,currMask,[0,0,0],'spotKern','convFunc');
    carvedCamVar                = carveOutWithMask(cameraVarianceInElectrons,currMask,[0,0,0]);
    carvedMask                  = carveOutWithMask(currMask,currMask,[0,0,0]);
    carvedRectSubArrayIdx       = stats(1).SubarrayIdx;
    carvedEstimates.spotKern    = estimated.spotKern;
    %-----APPY MY FUNC-------------------------------------------------
    MLEs{ii}                 = doMultiEmitterFitting(carvedMask,carvedRectSubArrayIdx,carvedDatas,carvedEstimates,carvedCamVar,Kmatrix,psfObjs,'theta0',myTheta0s,'numSpots',numSpots,'doPlotEveryN',doPlotEveryN,'DLLDLambda',params.DLLDLambda);
end

MLEsregular = cell(params.numSamples,1);
sizeKern        = size(psfs{1});

setupParForProgress(params.numSamples);
parfor ii = 1:params.numSamples
    incrementParForProgress();
    camVar                       = params.NoiseFunc(params.NoiseFuncArgs{:});
    [stack,~,cameraParams]       = genMicroscopeNoise(bigLambdas,'readNoiseData',camVar);
    cameraVarianceInElectrons   = cameraParams.cameraVarianceInADU.*(cameraParams.gainElectronPerCount.^2);
    [~,photonData]              = returnElectrons(stack,cameraParams);
    estimated                   = findSpotsStage1V2(photonData,psfs,cameraVarianceInElectrons,'kMatrix',Kmatrix);
    myTheta0s                   = genSequenceOfThetas(bigTheta,estimated);
    % define candidates
    L = zeros(size(stack{1}));
    spotCoors = getSpotCoorsFromTheta(bigTheta);
    for zz = 1:numel(spotCoors)
        cellCoor = num2cell(spotCoors{zz});
        L(cellCoor{:}) = 1;
    end
    
    
    L = imdilate(L,strel(ones(sizeKern(:)')));
    L = bwlabeln(L>0);
    stats = regionprops(L,'PixelList','SubarrayIdx','PixelIdxList');
    
    currMask = L == 1;
    carvedDatas                 = carveOutWithMask(photonData,currMask,[0,0,0]);
    carvedEstimates             = carveOutWithMask(estimated,currMask,[0,0,0],'spotKern','convFunc');
    carvedCamVar                = carveOutWithMask(cameraVarianceInElectrons,currMask,[0,0,0]);
    carvedMask                  = carveOutWithMask(currMask,currMask,[0,0,0]);
    carvedRectSubArrayIdx       = stats(1).SubarrayIdx;
    carvedEstimates.spotKern    = estimated.spotKern;
    %-----APPY MY FUNC-------------------------------------------------
    MLEsregular{ii}                 = doMultiEmitterFitting(carvedMask,carvedRectSubArrayIdx,carvedDatas,carvedEstimates,carvedCamVar,Kmatrix,psfObjs,'theta0',myTheta0s,'numSpots',numSpots,'doPlotEveryN',doPlotEveryN,'DLLDLambda',params.DLLDLambda);
end

% plot MLEs
regular = [];
inverted  = [];

for ii = 1:numel(MLEs)
    display(ii);
    if numel(MLEs{ii}) == 3 && numel(MLEsregular{ii}) == 3
        xyzabs = getXYZABFromTheta(MLEs{ii}(3).theta0s);
        xyzabsregular = getXYZABFromTheta(MLEsregular{ii}(3).theta0s);
        
        regular(end+1) = xyzabsregular{1}{1}(1);
        regular(end+1) = xyzabsregular{2}{1}(1);
        inverted(end+1) = xyzabs{1}{1}(1);
        inverted(end+1) = xyzabs{2}{1}(1);
    end
end

histogram(regular(2:2:end));hold on;histogram(inverted(2:2:end));

figure;
histogram(regular(1:2:end));hold on;histogram(inverted(1:2:end));

%% check field estimators
patchSize = [31 31 31];
sigmassq1 = [2,2,2];
[kern1,~] = ndGauss(sigmassq1,patchSize);
kernSize = [7 7 7];
domains = genMeshFromData(kern1);
[gradientFieldFilters,hessFeldFilters,kerns] = genFieldFilters(kernSize,kern1);

kernObj = myPattern_Numeric(kern1);
coor1 = getCenterCoor(patchSize);
buildThetas = {{kernObj,[2 coor1]},{0}};
thetaInputs = {1,buildThetas};
bigLambdas = bigLambda(domains,thetaInputs);
cameraVariance = ones(size(bigLambdas{1}));


Kmatrix = [1 0.3;0.2 1];
psfs    = {ndGauss([0.9,0.9,0.9],[7 7 7]),ndGauss([1.2,1.2,1.2],[7 7 7])};
theta1  = {[10 3 3 3],[5 20 20 20],5};
theta2  = {[6 10 10 10], 5};
thetas  = {theta1,theta2};
[ bigThetas,objKerns ] = genBigTheta(Kmatrix,psfs,thetas);


N = 10000;
signal = num2cell(coor1);
bkgnd  = num2cell(coor1 + kernSize);
sigLL = zeros(N,1);
bkLL = zeros(N,1);

parfor ii = 1:N
    display(ii);
    [sampledData,~,cameraParams] = genMicroscopeNoise(bigLambdas{1});
    electronData = returnElectrons(sampledData,cameraParams);
    estimated = findSpotsStage1V2(electronData,kerns.kern,cameraVariance);
    estField = fieldEstimator(electronData,kerns.kern,cameraVariance);
    sigLL(ii) = estimated.LLRatio(signal{:});
    bkLL(ii) = estimated.LLRatio(bkgnd{:});
    
end

LL = genROC('LLRatio',sigLL,bkLL);

gradOfData = calcFullGradientFilter(electronData,estimated,kerns.kern,kerns.kernDs,cameraVariance);
% hessOfData = calcFullHessianFilter(electronData,estimated,kerns.kern,kerns.kernDs,kerns.kernD2s,cameraVariance);
%
%  [gradDotProduct] = convFieldKernels(gradOfData,gradientFieldFilters);
[gradXYZDotProduct] = convFieldKernels(gradOfData(3:end),gradientFieldFilters(3:end));


%% check LOG3D against numerical derivative of gaussian to check
% looks good

%
sigma = 11;
patch = 101;
sV = [sigma,sigma,sigma];
pV = [patch,patch,patch];
myLog = LOG3D(sV,pV);
myGauss = ndGauss(sV,pV);
% [myLogProfiles] = getNDXYZProfiles(myLog);
% [myGaussProfiles] = getNDXYZProfiles(myGauss);
[xx,yy,zz] = gradient(myGauss);
[xx,~,~] = gradient(xx);
[~,yy,~] = gradient(yy);
[~,~,zz] = gradient(zz);
estLap = xx + yy + zz;
imtool3D(cat(2,norm0to1(-estLap),norm0to1(myLog)))


%% check poissGauss derivatives
% so far looks good
d = -3:5:20;
readNoise = 1.6;
lambda = linspace(0,25,100);
order = 2;
for ii = 1:numel(d)
    for jj = 1:numel(lambda)
        % this is wrong because it is returning D of the likelihood not the
        % log likelhood
        dpg(jj) = DLLDLambda_PoissGauss(d(ii),lambda(jj),readNoise^2,order);
    end
    hold on;plot(lambda,dpg,'-');
end
legend(arrayfun(@(x) ['d=' num2str(x)],d,'UniformOutput',false));
xlabel('lambda');
for ii = 1:numel(d)
    for jj = 1:numel(lambda)
        % this is wrong because it is returning D of the likelihood not the
        % log likelhood
        dpp(jj) = DLLDLambda_PoissPoiss(d(ii),lambda(jj),readNoise^2,order);% DPoissDLambdaPDF(d(ii)+readNoise^2,lambda(jj)+readNoise^2);
    end
    plot(lambda,dpp,'--');
end
%% test discrimination ability of two spots
Kmatrix = [1 0; 0 1];
binning = 3;
params.sizeData         = [31 21 9];
params.centerCoor       = round(params.sizeData/2);

params.psfFunc          = @genPSF;
params.psfFuncArgs      = {{'lambda',514e-9,'f',binning,'mode',0},{'lambda',610e-9,'f',binning,'mode',0}};
params.threshPSFArgs    = {[11,11,11]};
params.NoiseFunc        = @genSCMOSNoiseVar;
params.NoiseFuncArgs    = {params.sizeData,'scanType','slow'};

params.As               = 3;
params.Bs               = 0;
params.dist2Spots       = 0;

cameraVar          = params.NoiseFunc(params.NoiseFuncArgs{:});

centerCoor = params.centerCoor ;
psfs        = cellfunNonUniformOutput(@(x) params.psfFunc(x{:}),params.psfFuncArgs);
psfs        = cellfunNonUniformOutput(@(x) centerGenPSF(x),psfs);
psfObjs     = cellfunNonUniformOutput(@(x) myPattern_Numeric(x,'downSample',[binning,binning,binning]),psfs);
psfs        = cellfunNonUniformOutput(@(x) x.returnShape,psfObjs);
psfs        = cellfunNonUniformOutput(@(x) threshPSF(x,params.threshPSFArgs{:}),psfs);

domains     = genMeshFromData(zeros(params.sizeData));
secondCoor = centerCoor+[params.dist2Spots 0 0];
spotCoors = {{[params.As centerCoor],params.Bs},{[params.As secondCoor],params.Bs}};

bigTheta    = genBigTheta(Kmatrix,psfObjs,spotCoors);

bigLambdas  = bigLambda(domains,bigTheta,'objKerns',psfObjs);
[sampledData,~,cameraParams] = genMicroscopeNoise(bigLambdas,'readNoiseData',cameraVar);
[~,photonData] = returnElectrons(sampledData,cameraParams);

estimated = findSpotsStage1V2(photonData,psfs,cameraVar,'kMatrix',Kmatrix,'nonNegativity',true);
candidates = genCandidatesFromTheta0(params.sizeData,bigTheta,params.threshPSFArgs{1});
% candidatesSep = selectCandidates(estimatedSep);

MLEs = findSpotsStage2V2(photonData,cameraVar,estimated,candidates,Kmatrix,psfObjs,'doPlotEveryN',10,'DLLDLambda',@DLLDLambda_PoissGauss);

mse(1) = logLike_MSE(photonData,bigLambda(domains,MLEs{1}(1).thetaMLEs,'objKerns',psfObjs));
mse(2) = logLike_MSE(photonData,bigLambda(domains,MLEs{1}(2).thetaMLEs,'objKerns',psfObjs));
mse(3) = logLike_MSE(photonData,bigLambda(domains,MLEs{1}(2).thetaMLEs,'objKerns',psfObjs));

LLPP = [MLEs{1}.logLikePP];
LLPG = [MLEs{1}.logLikePG];

figure;
plot(norm0to1(mse),'-x');hold on;
plot(norm0to1(LLPP),'-o');
plot(norm0to1(LLPG),'-s');
legend('mse','pp','pg');
%% confirm convergence quality for 1 channel 2 spots
Kmatrix = 1;
binning = 3;
params.sizeData         = [42 21 9];
params.centerCoor       = round(params.sizeData/2);

params.psfFunc          = @genPSF;
params.psfFuncArgs      = {{'lambda',514e-9,'f',binning,'mode',0},{'lambda',610e-9,'f',binning,'mode',0}};
params.threshPSFArgs    = {[11,11,11]};
params.NoiseFunc        = @genSCMOSNoiseVar;
params.NoiseFuncArgs    = {params.sizeData,'scanType','slow'};

params.As               = 3;
params.Bs               = 0;
params.dist2Spots       = 0;

cameraVar          = params.NoiseFunc(params.NoiseFuncArgs{:});

centerCoor = params.centerCoor ;
psfs        = cellfunNonUniformOutput(@(x) params.psfFunc(x{:}),params.psfFuncArgs);
psfs        = cellfunNonUniformOutput(@(x) centerGenPSF(x),psfs);
psfObjs     = cellfunNonUniformOutput(@(x) myPattern_Numeric(x,'downSample',[binning,binning,binning]),psfs);
psfs        = cellfunNonUniformOutput(@(x) x.returnShape,psfObjs);
psfs        = cellfunNonUniformOutput(@(x) threshPSF(x,params.threshPSFArgs{:}),psfs);

psfs = psfs(1);
psfObjs = psfObjs(1);
domains     = genMeshFromData(zeros(params.sizeData));
secondCoor = centerCoor+[params.dist2Spots 0 0];
spotCoors = {{[params.As centerCoor],[params.As secondCoor],params.Bs}};

bigTheta    = genBigTheta(Kmatrix,psfObjs,spotCoors);

bigLambdas  = bigLambda(domains,bigTheta,'objKerns',psfObjs);
[sampledData,~,cameraParams] = genMicroscopeNoise(bigLambdas,'readNoiseData',cameraVar);
[~,photonData] = returnElectrons(sampledData,cameraParams);

estimated = findSpotsStage1V2(photonData,psfs,cameraVar,'kMatrix',Kmatrix,'nonNegativity',true);
candidates = selectCandidates(estimated,'strategy','otsu');
plot3Dstack(candidates.L);
% candidatesSep = selectCandidates(estimatedSep);

MLEs = findSpotsStage2V2(photonData,cameraVar,estimated,candidates,Kmatrix,psfObjs,'doPlotEveryN',10);

%% confirm convergence quality for 2 spots
% alright fixed bugs and it works!
Kmatrix = [1 0.5; 0 1];
binning = 3;
params.sizeData         = [42 21 9];
params.centerCoor       = round(params.sizeData/2);

params.psfFunc          = @genPSF;
params.psfFuncArgs      = {{'lambda',514e-9,'f',binning,'mode',0},{'lambda',810e-9,'f',binning,'mode',0}};
params.threshPSFArgs    = {[11,11,11]};
params.NoiseFunc        = @genSCMOSNoiseVar;
params.NoiseFuncArgs    = {params.sizeData,'scanType','slow'};

params.As               = 10000;
params.Bs               = 0;
params.dist2Spots       = 4;

cameraVar          = params.NoiseFunc(params.NoiseFuncArgs{:});

centerCoor = params.centerCoor ;
psfs        = cellfunNonUniformOutput(@(x) params.psfFunc(x{:}),params.psfFuncArgs);
psfs        = cellfunNonUniformOutput(@(x) centerGenPSF(x),psfs);
psfObjs     = cellfunNonUniformOutput(@(x) myPattern_Numeric(x,'downSample',[binning,binning,binning]),psfs);
psfs        = cellfunNonUniformOutput(@(x) x.returnShape,psfObjs);
psfs        = cellfunNonUniformOutput(@(x) threshPSF(x,params.threshPSFArgs{:}),psfs);

domains     = genMeshFromData(zeros(params.sizeData));
secondCoor = centerCoor+[params.dist2Spots 0 0];
spotCoors = {{[params.As centerCoor],params.Bs},{[params.As*2 secondCoor],params.Bs}};
bigTheta    = genBigTheta(Kmatrix,psfObjs,spotCoors);

bigLambdas  = bigLambda(domains,bigTheta,'objKerns',psfObjs);
[sampledData,~,cameraParams] = genMicroscopeNoise(bigLambdas,'readNoiseData',cameraVar);
[~,photonData] = returnElectrons(sampledData,cameraParams);

estimated = findSpotsStage1V2(photonData,psfs,cameraVar,'kMatrix',Kmatrix,'nonNegativity',true);
candidates = selectCandidates(estimated,'strategy','otsu');
plot3Dstack(candidates.L);
% candidatesSep = selectCandidates(estimatedSep);

MLEs = findSpotsStage2V2(photonData,cameraVar,estimated,candidates,Kmatrix,psfObjs,'doPlotEveryN',10);

%% lets check low snr 2 channel and compare against gaussian
%
% notes. ROC for 1 photon peak is at 50%
%        - LOG 3d filter doesn't do so well.
%        - there is a significant performance increase if you use real psf
%        versus gaussian approximation.  the more symmetric the psf is in
%        z, the less this difference is.

close all;
clear;
psfSize     = [17,17,17];
psfSizeForFilter = [11,11,11];
domainSize  = [29 29 29];
centerCoor = round(domainSize/2);
psfArgs = {{'lambda',514e-9,'onlyPSF',false,'Ns',1.33},{'lambda',610e-9,'onlyPSF',false,'Ns',1.33}};
psfsStructs        = cellfunNonUniformOutput(@(x) genPSF(x{:}),psfArgs);
close all;
psfs        = cellfunNonUniformOutput(@(x) x.glPSF,psfsStructs);
gausses     = cellfunNonUniformOutput(@(x) x.gaussKern,psfsStructs);
psfs        = cellfunNonUniformOutput(@(x) threshPSF(x,psfSize),psfs);
gausses     = cellfunNonUniformOutput(@(x) threshPSF(x,psfSize),gausses);
psfObjs     = cellfunNonUniformOutput(@(x) myPattern_Numeric(x),psfs);
gaussObjs   = cellfunNonUniformOutput(@(x) myPattern_Numeric(x),gausses);
psfs        = cellfunNonUniformOutput(@(x) threshPSF(x,psfSizeForFilter),psfs);
gausses     = cellfunNonUniformOutput(@(x) threshPSF(x,psfSizeForFilter),gausses);
logFilters  = {LOG3D(psfsStructs{1}.gaussSigmas.^2  ,psfSizeForFilter),LOG3D(psfsStructs{1}.gaussSigmas.^2  ,psfSizeForFilter)};

domains = genMeshFromData(ones(domainSize));

buildThetas1 = {{psfObjs{1},[1 centerCoor]},{0}};
buildThetas2 = {{psfObjs{2},[1 centerCoor]},{0}};
Kmatrix      = [1 0.2; 0.2 1];
thetaInputs2 = {buildThetas1,buildThetas2};
thetaInputs2 = {Kmatrix,thetaInputs2{:}};

[bigLambdas,~,~] = bigLambda(domains,thetaInputs2,'objKerns',psfObjs);

N = 1000;
sigFull = zeros(N,1);
bkgndFull = cell(N,1);
sigWG  = zeros(N,1);
bkgndWG = cell(N,1);


parfor ii = 1:N
    display(ii);
    [sampledData,~,cameraParams] = genMicroscopeNoise(bigLambdas);
    [~,photonData] = returnElectrons(sampledData,cameraParams);
    estimatedSep = findSpotsStage1V2(photonData,psfs,ones(size(bigLambdas{1})),'kMatrix',Kmatrix,'nonNegativity',false);
    estimatedWG = findSpotsStage1V2(photonData,gausses,ones(size(bigLambdas{1})),'kMatrix',Kmatrix,'nonNegativity',false);
    
    chan1 = convFFTND(photonData{1},logFilters{1});
    chan2 = convFFTND(photonData{2},logFilters{2});
    chan = chan1 + chan2;
    [sigFull(ii),bkgndFull{ii} ] = measureSigBkgnd(estimatedSep.LLRatio,centerCoor,psfSize);
    [sigWG(ii),bkgndWG{ii} ] = measureSigBkgnd(estimatedWG.LLRatio,centerCoor,psfSize);
end
bkgndFull =cell2mat(bkgndFull);
bkgndWG   = cell2mat(bkgndWG);
full = genROC('FULLPSF',sigFull,bkgndFull);
WG = genROC('gaussPSF',sigWG,bkgndWG);
figure;plot(1-full.withoutTargetCDF,1-full.withTargetCDF);hold on;plot(1-WG.withoutTargetCDF,1-WG.withTargetCDF);
legend('fullPSF','gaussPSF');

plot3Dstack(catNorm(estimatedSep.LLRatio,estimatedWG.LLRatio));
drawnow;
candidates = selectCandidates(estimatedSep,'strategy','otsu');
plot3Dstack(candidates.L);
drawnow;
% candidatesSep = selectCandidates(estimatedSep);

MLEs = findSpotsStage2V2(photonData,ones(size(bigLambdas{1})),estimatedSep,candidates,Kmatrix,psfObjs,'plotEveryN',10);


%% genROC checked against publication.
%"Advantages to transforming the receiver operating characteristic (ROC)
%curve into likelihood ratio co-ordinates"
close all;
muB = 5;
sigmaB = 1;
muS = 8;
sigmaS = 1;
N = 100;
myFunc = @(x) x.^5 + 10;
bkgnd = normrnd(muB,sigmaB,N);
signal = normrnd(muS,sigmaS,N);
hb = histogram(bkgnd);
hold on;hs = histogram(signal);
reg = genROC('0 1 1 1',signal,bkgnd);

reg = genROC('0 1 1 1',signal,bkgnd);
powered = genROC('0 1 1 1 powered',myFunc(signal),myFunc(bkgnd));
figure;plot(1-reg.withoutTargetCDF,1-reg.withTargetCDF);hold on;plot(1-powered.withoutTargetCDF,1-powered.withTargetCDF,'--');
% ROC is indepdent of transofmration

%% figure out the gradient field stuff by checking the residuals

%% test filter generation, just a plurality of bkgnd and signal intensities and see if single threshold can win
patchSize = [31 31 31];
sigmassq1 = [2,2,2];
[kern1,~] = ndGauss(sigmassq1,patchSize);
kernSize = [7 7 7];
domains = genMeshFromData(kern1);
[gradientFieldFilters,hessFieldFilters,kerns] = genFieldFilters(kernSize,kern1);

kernObj = myPattern_Numeric(kern1);
coor1 = getCenterCoor(patchSize);
buildThetas = {{kernObj,[2 coor1]},{0}};
thetaInputs = {1,buildThetas};
bigLambdas = bigLambda(domains,thetaInputs);
cameraVariance = ones(size(bigLambdas{1}));


Kmatrix = [1 0.3;0.2 1];
psfs    = {ndGauss([0.9,0.9,0.9],[7 7 7]),ndGauss([1.2,1.2,1.2],[7 7 7])};
theta1  = {[10 3 3 3],[5 20 20 20],5};
theta2  = {[6 10 10 10], 5};
thetas  = {theta1,theta2};
[ bigThetas,objKerns ] = genBigTheta(Kmatrix,psfs,thetas);


N = 10000;
signal = num2cell(coor1);
bkgnd  = num2cell(coor1 + kernSize);
sigLL = zeros(N,1);
bkLL = zeros(N,1);

parfor ii = 1:N
    display(ii);
    [sampledData,~,cameraParams] = genMicroscopeNoise(bigLambdas{1});
    electronData = returnElectrons(sampledData,cameraParams);
    estimated = findSpotsStage1V2(electronData,kerns.kern,cameraVariance);
    
    sigLL(ii) = estimated.LLRatio(signal{:});
    bkLL(ii) = estimated.LLRatio(bkgnd{:});
    
end

LL = genROC('LLRatio',sigLL,bkLL);

gradOfData = calcFullGradientFilter(electronData,estimated,kerns.kern,kerns.kernDs,cameraVariance);
% hessOfData = calcFullHessianFilter(electronData,estimated,kerns.kern,kerns.kernDs,kerns.kernD2s,cameraVariance);
%
%  [gradDotProduct] = convFieldKernels(gradOfData,gradientFieldFilters);
[gradXYZDotProduct] = convFieldKernels(gradOfData(3:end),gradientFieldFilters(3:end));
% [gradABDotProduct] = convFieldKernels(gradOfData(1:2),gradientFieldFilters(1:2));
%
% [hessDotProduct] = convFieldKernels(hessOfData,hessFieldFilters);
% temp = hessFieldFilters;
% temp(1,:) = {[]};
% temp(2,:) = {[]};
% [hessXYZDotProducttemp] = convFieldKernels(hessOfData,temp);


% plot3Dstack(cat(2,norm0to1(templateMatch.^20),norm0to1(estimated.LLRatio),norm0to1(gradXYZDotProduct),norm0to1(gradXYZDotProduct.*hessXYZDotProducttemp),norm0to1(hessXYZDotProducttemp)));
%% test expanded gradient filter, A,B and xyz
patchSize = [21 21 21];
sigmassq1 = [2,2,2];
[kern1,~] = ndGauss(sigmassq1,patchSize);
domains = genMeshFromData(kern1);
cameraVariance = ones(size(kern1));
kernObj = myPattern_Numeric(kern1);
coor1 = getCenterCoor(patchSize) + 3;
buildThetas = {{kernObj,[10 coor1]},{8}};
thetaInputs = {1,buildThetas};
[lambdas,gradLambdas,hessLambdas] = kernObj.givenThetaGetDerivatives(domains,getCenterCoor(patchSize),[1 1 1]);
kern = cropCenterSize(lambdas,[7,7,7]);
kernDs = cellfunNonUniformOutput(@(x)cropCenterSize(x,[7,7,7]),gradLambdas);
kernD2s = cellfunNonUniformOutput(@(x)cropCenterSize(x,[7,7,7]),hessLambdas);
bigLambdas = bigLambda(domains,thetaInputs);
[sampledData,poissonNoiseOnly,cameraParams] = genMicroscopeNoise(bigLambdas{1});
electronData = returnElectrons(sampledData,cameraParams);
estimated = findSpotsStage1V2(kern1,kern,cameraVariance);
gradients = calcFullGradientFilter(kern1,estimated,kern,kernDs,cameraVariance);
gradientAB = calcABGradientFilter(kern1,estimated,kern,cameraVariance);
hessians  = calcHessianFilter(kern1,estimated,kern,kernDs,kernD2s,cameraVariance);
[ fullHess ] = calcFullHessianFilter(kern1,estimated,kern,kernDs,kernD2s,cameraVariance);
%CALCHESSIAN Summary of this function goes here
quiver3(domains{:},gradientsXYZ{:});
hold on;quiver3(domains{:},fullHess{[1,7,13]});
figure;colorQuiver3(domains{:},gradientsXYZ{1},gradientAB{:});
figure;colorQuiver3(domains{:},gradientsXYZ{1:2},gradientAB{1});xlabel('x');ylabel('y');zlabel('z');
figure;colorQuiver3(domains{:},hessians{[1,5,9]});
%% lets test a 1 channel stage 3
close all;
clear;
binningXY   = [1 1 1];
patchSize = binningXY*31;
sigmassq1 = [2,2,2].*binningXY.^2;
sigmassq2 = [3,3,3].*binningXY.^2;
[kern1,kern1Sep] = ndGauss(sigmassq1,patchSize);
[kern2,kern2Sep] = ndGauss(sigmassq2,patchSize);
domains = genMeshFromData(kern1);
kernObj1 = myPattern_Numeric(kern1,'binning',binningXY);
kernObj2 = myPattern_Numeric(kern2,'binning',binningXY);
kernObjList  = {kernObj1,kernObj2};
buildThetas1 = {{kernObj1,[5 8 15 16]},{0}};
buildThetas2 = {{kernObj2,[5 8.5 15.5 16.5]},{0}};
Kmatrix      = [1 0.3; 0.3 1];
thetaInputs2 = {buildThetas1,buildThetas2};
thetaInputs2 = {Kmatrix,thetaInputs2{:}};
kern1 = threshPSF(kern1,0.015);
kern1Sep = cropCenterSize(kern1Sep,size(kern1));
kern2Sep = cropCenterSize(kern2Sep,size(kern1));
[bigLambdas,bigDLambdas,bigD2Lambdas] = bigLambda(domains,thetaInputs2,'objKerns',kernObjList);
[sampledData,~,cameraParams] = genMicroscopeNoise(bigLambdas);
[~,photonData] = returnElectrons(sampledData,cameraParams);
estimatedSep = findSpotsStage1V2(photonData,{kern1Sep,kern2Sep},ones(size(bigLambdas{1})),'kMatrix',Kmatrix,'nonNegativity',false);

candidates = selectCandidates(estimatedSep);
% plot3Dstack(candidates.L);
% candidatesSep = selectCandidates(estimatedSep);

MLEs = findSpotsStage2V2(photonData,ones(size(bigLambdas{1})),estimatedSep,candidates,Kmatrix,{kernObj1,kernObj2});

%% lets test a 1 channel stage 3
close all;
clear;
binningXY   = [1 1 1];
patchSize = binningXY*31;
sigmassq1 = [2,2,2].*binningXY.^2;
[kern1,kern1Sep] = ndGauss(sigmassq1,patchSize);
domains = genMeshFromData(kern1);
kernObj1 = myPattern_Numeric(kern1,'binning',binningXY);
buildThetas1 = {{kernObj1,[7 8.5 15.5 16.5]},{kernObj1,[7 11.5 18.5 19.5]},{0}};
Kmatrix      = 1;
thetaInputs2 = {buildThetas1};
thetaInputs2 = {Kmatrix,thetaInputs2{:}};
kern1 = threshPSF(kern1,0.015);
kern1Sep = cropCenterSize(kern1Sep,size(kern1));
[bigLambdas,bigDLambdas,bigD2Lambdas] = bigLambda(domains,thetaInputs2);
[sampledData,~,cameraParams] = genMicroscopeNoise(bigLambdas);
[~,photonData] = returnElectrons(sampledData,cameraParams);
estimatedSep = findSpotsStage1V2(photonData,{kern1Sep},ones(size(bigLambdas{1})),'kMatrix',Kmatrix,'nonNegativity',false);

candidates = selectCandidates(estimatedSep);
% plot3Dstack(candidates.L);
% candidatesSep = selectCandidates(estimatedSep);

[MLEs] = findSpotsStage2V2(photonData,ones(size(bigLambdas{1})),estimatedSep,candidates,Kmatrix,{kernObj1});
%% lets start building stage 3
close all;
clear;
binningXY   = [1 1 1];
patchSize = binningXY*31;
sigmassq1 = [2,2,2].*binningXY.^2;
sigmassq2 = [3,3,3].*binningXY.^2;
sigmassq3 = [4,4,4].*binningXY.^2;
% build the numeric multi emitter
[kern1,kern1Sep] = ndGauss(sigmassq1,patchSize);
[kern2,kern2Sep] = ndGauss(sigmassq2,patchSize);
[kern3,kern3Sep] = ndGauss(sigmassq3,patchSize);
domains = genMeshFromData(kern1);
kernObj1 = myPattern_Numeric(kern1,'binning',binningXY);
kernObj2 = myPattern_Numeric(kern2,'binning',binningXY);
kernObj3 = myPattern_Numeric(kern3,'binning',binningXY);

buildThetas1 = {{kernObj1,[7 8 15 16]},{kernObj1,[7 15 4 14]},{0}};
buildThetas2 = {{kernObj2,[7 5 12 13]},{0}};
buildThetas3 = {{kernObj3,[7 20 20 20]},{0}};
Kmatrix      = [1 0.5 0.5;0.2 1 0.5; 0.5 0.5 1];
% Kmatrix      = eye(size(Kmatrix));
thetaInputs2 = {buildThetas1,buildThetas2,buildThetas3};
thetaInputs2 = {Kmatrix,thetaInputs2{:}};



% build max theta
buildMaxThetas1 = {[1 1 1 1],[1 1 1 1],1};
buildMaxThetas2 = {[1 1 1 1],1};
buildMaxThetas3 = {[1 1 1 1],1};
kmatrixMax      = zeros(size(Kmatrix));
maxThetaInput = {buildMaxThetas1,buildMaxThetas2,buildMaxThetas3};
maxThetaInput = {kmatrixMax,maxThetaInput{:}};

kern3 = threshPSF(kern3,0.015);
kern2 = cropCenterSize(kern2,size(kern3));
kern1 = cropCenterSize(kern1,size(kern3));

kern1Sep = cropCenterSize(kern1Sep,size(kern3));
kern2Sep = cropCenterSize(kern2Sep,size(kern3));
kern3Sep = cropCenterSize(kern3Sep,size(kern3));

[bigLambdas,bigDLambdas,bigD2Lambdas] = bigLambda(domains,thetaInputs2);
[sampledData,~,cameraParams] = genMicroscopeNoise(bigLambdas);
[~,photonData] = returnElectrons(sampledData,cameraParams);

estimated = findSpotsStage1V2(photonData,{kern1,kern2,kern3},ones(size(bigLambdas{1})),'kMatrix',Kmatrix,'nonNegativity',false);
estimatedSep = findSpotsStage1V2(photonData,{kern1Sep,kern2Sep,kern3Sep},ones(size(bigLambdas{1})),'kMatrix',Kmatrix,'nonNegativity',false);

candidates = selectCandidates(estimated,'LLRatioThresh',7500);
% candidatesSep = selectCandidates(estimatedSep);

[MLEs] = findSpotsStage2V2(photonData,ones(size(bigLambdas{1})),estimated,candidates,Kmatrix,{kernObj1,kernObj2,kernObj3});


%% i find binning sort of slow and unnecessary. linear interpolation is
% the best compromise
% first try a 3D psf in which binning is only done in xy and none in z
% so binnning is a legacy word.  it now means upsample fact
close all;
binningXY = 3;
binningZ  = 3;
psfSize  = [21 21 21];
binMode = [binningXY,binningXY,binningZ];
psf = genPSF('f',binningXY,'mode',0);
psf = threshPSF(psf,psfSize.*[binningXY,binningXY,binningXY]);
psfBinned = NDbinData(psf,[binningXY,binningXY,binningXY]);

domainsPSF = genMeshFromData(psf);
% correct for over sampled PSF domains
domainsPSF = cellfunNonUniformOutput(@(x,y) x/y, domainsPSF,{binningXY,binningXY,binningXY}');
kernObj1   = myPattern_Numeric(psf,'binning',binMode,'domains',domainsPSF);
domainSize = 25;
domainsNew = genMeshFromData(zeros(domainSize,domainSize,domainSize));

writerObj = VideoWriter('binning3D.avi'); % Name it.
writerObj.FrameRate = 60; % How many frames per second.
writerObj.Quality = 100;
open(writerObj);

timeSteps = 10000;
epsilon = 0.1;
border = 10;
initialVector = rand(3,1);
initialVector = initialVector / sqrt(sum(initialVector.^2));
init0 = rand(3,1)*(domainSize-border/2) + border/2;

M = 60;
pixelSize = 6.5e-06;
xyUnits = pixelSize/M;
params.dz           = 0.25e-6;
params.zSteps       = 25;
params.z0           = -2e-6;
z = params.z0:params.dz:(params.z0 + params.dz*(params.zSteps-1));
xy = (-floor(domainSize/2):floor(domainSize/2))*xyUnits;
truePSF = genPSF('xp',interp1(1:domainSize,xy,init0(1)),'yp',interp1(1:domainSize,xy,init0(2)),'zp',interp1(1:domainSize,z,init0(3)));
% setup initial plot
[lambda,~] = kernObj1.givenTheta(domainsNew,init0);
plot3Dstack(cat(2,truePSF*max(lambda(:)),lambda),'cRange',[0 1])

for ii = 1:timeSteps
    [lambda,~] = kernObj1.givenTheta(domainsNew,init0);
    truePSF = genPSF('xp',interp1(1:domainSize,xy,init0(1)),'yp',interp1(1:domainSize,xy,init0(2)),'zp',interp1(1:domainSize,z,init0(3)));
    truePSF = truePSF * max(lambda(:));
    clf;
    plot3Dstack(cat(2,truePSF,lambda),'cRange',[0 1],'keepFigure',true);
    colormap default;
    drawnow;
    writeVideo(writerObj,getframe(gcf));
    init0 = init0 + initialVector*epsilon;
    initialVector(init0<border/2) = -initialVector(init0<border/2);
    initialVector(init0>(domainSize-border/2)) = -initialVector(init0>(domainSize-border/2));
    display(init0);
end
close(writerObj);




%% check binning
binningXY = 5;
patchSize = 21;
sigma = 0.9;

% 1 D case
A = ndGauss([sigma]*binningXY.^2,binningXY*[patchSize] + 2);
out = NDbinData(A,binningXY);
% to center binned version, you need to correct for the middle of the width
% of the bin.  -floor(binning/2)/binning  the CCD integration lines need to
% be shifted by 0.5 [1:binning:(numel(A)+1)]-0.5)/binning
%
% most importantly, the original gaussian needs to have its domain
% rescaled [1:numel(A)]/binning to account for the fact there are many more
% pixels
figure;plot([1:numel(A)]/binningXY,A);hold on;plot([1:numel(out)]-floor(binningXY/2)/binningXY,out);
stem(([1:binningXY:(numel(A)+1)]-0.5)/binningXY,ones(numel(out),1));
% note that a peak of 1 in original shape gets changed when you bin because
% it sums up the bins.
myMax = [];
close all;
mu = [(0:0.1:binningXY*(patchSize/2 + 2))];
F(numel(mu)) = struct('cdata',[],'colormap',[]);

writerObj = VideoWriter('binning1D.avi'); % Name it.
writerObj.FrameRate = 30; % How many frames per second.
writerObj.Quality = 100;
open(writerObj);

% this makes a movie so you can see the gaussian shape move between CCD
% integration and see the new values.
for ii = 1:numel(mu)
    A = ndGauss([sigma]*binningXY.^2,binningXY*[ patchSize]+2,[mu(ii)]);
    out = NDbinData(A,[binningXY]);
    clf;
    plot([1:numel(A)]/binningXY,A,'LineWidth',2);hold on;plot([1:numel(out)]-floor(binningXY/2)/binningXY,out,'-*','LineWidth',2);
    stem(([1:binningXY:(numel(A)+1)]-0.5)/binningXY,ones(numel(out),1));
    axis tight;
    box off;
    F(ii) = getframe(gcf);
    writeVideo(writerObj, F(ii));
    myMax(end+1) = max(out(:));
end
figure;plot(myMax);
close(writerObj);
% so the peak of the binned object does not reach its orginal peak of 1
% because the value is now the average.  but its ok.  it is stable...

% ok try to make a numeric object pattern and see if it works

% first try a 3D psf in which binning is only done in xy and none in z
close all;
binningXY = 3;
binningZ  = 3;
psfSize  = [15 15 15];
binMode = [binningXY,binningXY,binningZ];
psf = genPSF('f',binningXY,'mode',0);
psf = threshPSF(psf,psfSize.*[binningXY,binningXY,binningXY]);
psfBinned = NDbinData(psf,[binningXY,binningXY,binningXY]);

domainsPSF = genMeshFromData(psf);
% correct for over sampled PSF domains
domainsPSF = cellfunNonUniformOutput(@(x,y) x/y, domainsPSF,{binningXY,binningXY,binningXY}');
kernObj1   = myPattern_Numeric(psf,'binning',binMode,'domains',domainsPSF);
domainSize = 25;
domainsNew = genMeshFromData(zeros(domainSize,domainSize,domainSize));

writerObj = VideoWriter('binning3D.avi'); % Name it.
writerObj.FrameRate = 60; % How many frames per second.
writerObj.Quality = 100;
open(writerObj);

timeSteps = 10000;
epsilon = 0.1;
border = 5;
initialVector = [1;1;1];
initialVector = initialVector / sqrt(sum(initialVector.^2));
init0 = rand(3,1)*(domainSize-border);

M = 60;
pixelSize = 6.5e-06;
xyUnits = pixelSize/M;
params.dz           = 0.25e-6;
params.zSteps       = 25;
params.z0           = -2e-6;
z = params.z0:params.dz:(params.z0 + params.dz*(params.zSteps-1));
xy = (-floor(domainSize/2):floor(domainSize/2))*xyUnits;
truePSF = genPSF('xp',interp1(1:domainSize,xy,init0(1)),'yp',interp1(1:domainSize,xy,init0(2)),'zp',interp1(1:domainSize,z,init0(3)));
% setup initial plot
[lambda,~] = kernObj1.givenTheta(domainsNew,init0);
lambda = lambda/max(lambda(:));
domainsUP{3} = 0;
[domainsUP{:}] = ndgrid(1:domainSize,1:domainSize,linspace(1,domainSize,domainSize*binningXY));
[~,nonBinned] = kernObj1.givenTheta(domainsUP,init0);
plot3Dstack(cat(2,imresize3(truePSF,size(nonBinned),'nearest'),imresize3(lambda,size(nonBinned),'nearest'),nonBinned),'cRange',[0 1]);

for ii = 1:timeSteps
    [lambda,~] = kernObj1.givenTheta(domainsNew,init0);
    domainsUP{3} = 0;
    [domainsUP{:}] = ndgrid(1:domainSize,1:domainSize,linspace(1,domainSize,domainSize*binningXY));
    [~,nonBinned] = kernObj1.givenTheta(domainsUP,init0);
    truePSF = genPSF('xp',interp1(1:domainSize,xy,init0(1)),'yp',interp1(1:domainSize,xy,init0(2)),'zp',interp1(1:domainSize,z,init0(3)));
    truePSF = truePSF * max(lambda(:));
    clf;
    plot3Dstack(cat(2,imresize3(truePSF,size(nonBinned),'nearest'),imresize3(lambda,size(nonBinned),'nearest'),nonBinned),'keepFigure',true,'cRange',[0 1]);
    colormap default;
    drawnow;
    writeVideo(writerObj,getframe(gcf));
    init0 = init0 + initialVector*epsilon;
    initialVector(init0<border) = -initialVector(init0<border);
    initialVector(init0>(domainSize-border)) = -initialVector(init0>(domainSize-border));
end
close(writerObj);

buildThetas1 = {{kernObj1,[7 8 15 16]},{kernObj1,[7 15 4 14]},{0}};
Kmatrix      = [1 0.5 0.5;0.2 1 0.5; 0.5 0.5 1];
% Kmatrix      = eye(size(Kmatrix));
thetaInputs2 = {buildThetas1,{},{}};
thetaInputs2 = {Kmatrix,thetaInputs2{:}};
[bigLambdas,bigDLambdas,bigD2Lambdas] = bigLambda(domains,thetaInputs2);

%% check myNumericPattern binning
close all;
clear;
binningXY   = 5;
patchSize = 61;
sigmas1   = [5,5,5];

% build the numeric multi emitter
[kern1,~] = ndGauss((binningXY*sigmas1).^2,[patchSize,patchSize,patchSize]*binningXY);
kernObj1 = myPattern_Numeric(kern1,'binning',[binningXY,binningXY,binningXY]);
[ogPattern,binned] = kernObj1.returnShape;
getNDXYZProfiles(ogPattern,'fitGaussian',true);
getNDXYZProfiles(binned,'fitGaussian',true);
% binned gaussian converges to real gaussian as sigma gets bigger.  so
% binning works
%
% lets see it work with a real PSF
binningXY = 5;
close all;
psf = genPSF('f',binningXY,'mode',0);
psfMaxCoors = findCoorWithMax(psf);
psfOG = genPSF();
psfOGMaxCoors = findCoorWithMax(psfOG);
psf = psf(:,:,psfMaxCoors{3});
psfOG = psfOG(:,:,psfOGMaxCoors{3});

psfObj = myPattern_Numeric(psf,'binning',[binningXY,binningXY]);
[ogPattern,binned] = psfObj.returnShape;


getNDXYZProfiles(psfOG,'fitGaussian',true);
getNDXYZProfiles(binned,'fitGaussian',true);
plot3Dstack(psfOG)
plot3Dstack(binned);
% it has small numerical error.
%% lets start building stage 3
close all;
clear;
binningXY   = [3 3 3];
patchSize = binningXY*31;
sigmassq1 = [2,2,2].*binningXY.^2;
sigmassq2 = [3,3,3].*binningXY.^2;
sigmassq3 = [4,4,4].*binningXY.^2;
% build the numeric multi emitter
[kern1,kern1Sep] = ndGauss(sigmassq1,patchSize);
[kern2,kern2Sep] = ndGauss(sigmassq2,patchSize);
[kern3,kern3Sep] = ndGauss(sigmassq3,patchSize);
domains = genMeshFromData(kern1);
kernObj1 = myPattern_Numeric(kern1,'binning',binningXY);
kernObj2 = myPattern_Numeric(kern2,'binning',binningXY);
kernObj3 = myPattern_Numeric(kern3,'binning',binningXY);

buildThetas1 = {{kernObj1,[7 8 15 16]},{kernObj1,[7 15 4 14]},{0}};
buildThetas2 = {{kernObj2,[7 5 12 13]},{0}};
buildThetas3 = {{kernObj3,[7 20 20 20]},{0}};
Kmatrix      = [1 0.5 0.5;0.2 1 0.5; 0.5 0.5 1];
% Kmatrix      = eye(size(Kmatrix));
thetaInputs2 = {buildThetas1,buildThetas2,buildThetas3};
thetaInputs2 = {Kmatrix,thetaInputs2{:}};

% build max theta
buildMaxThetas1 = {[1 1 1 1],[1 1 1 1],1};
buildMaxThetas2 = {[1 1 1 1],1};
buildMaxThetas3 = {[1 1 1 1],1};
kmatrixMax      = zeros(size(Kmatrix));
maxThetaInput = {buildMaxThetas1,buildMaxThetas2,buildMaxThetas3};
maxThetaInput = {kmatrixMax,maxThetaInput{:}};

kern3 = threshPSF(kern3,0.015);
kern2 = cropCenterSize(kern2,size(kern3));
kern1 = cropCenterSize(kern1,size(kern3));

kern1Sep = cropCenterSize(kern1Sep,size(kern3));
kern2Sep = cropCenterSize(kern2Sep,size(kern3));
kern3Sep = cropCenterSize(kern3Sep,size(kern3));

[bigLambdas,bigDLambdas,bigD2Lambdas] = bigLambda(domains,thetaInputs2);
[sampledData,~,cameraParams] = genMicroscopeNoise(bigLambdas);
[~,photonData] = returnElectrons(sampledData,cameraParams);

estimated = findSpotsStage1V2(photonData,{kern1,kern2,kern3},ones(size(bigLambdas{1})),'kMatrix',Kmatrix,'nonNegativity',false);
estimatedSep = findSpotsStage1V2(photonData,{kern1Sep,kern2Sep,kern3Sep},ones(size(bigLambdas{1})),'kMatrix',Kmatrix,'nonNegativity',false);

candidates = selectCandidates(estimated,'LLRatioThresh',7500);
% candidatesSep = selectCandidates(estimatedSep);

[MLEs] = findSpotsStage2V2(photonData,ones(size(bigLambdas{1})),estimated,candidates,{kernObj1,kernObj2,kernObj3},Kmatrix);

%% test gradient filter + llratio
% HOLLY SHIT.  dot prodcut of gradient field converging to fixed point
% assists LLRatio detection in ROC curve.  this means this outerforms
% LLRatio by itself!
% does it for both [10 coor1]},{8}
% and low photon [2 coor1]},{0}
%
% squaring the output also recapitulates much of this improvement.
patchSize = [21 21 21];
sigmassq1 = [2,2,2];
[kern1,~] = ndGauss(sigmassq1,patchSize);
domains = genMeshFromData(kern1);
cameraVariance = ones(size(kern1));
kernObj = myPattern_Numeric(kern1);
coor1 = getCenterCoor(patchSize) + 3;
buildThetas = {{kernObj,[1 coor1]},{1}};
thetaInputs = {1,buildThetas};
[lambdas,gradLambdas,hessLambdas] = kernObj.givenThetaGetDerivatives(domains,getCenterCoor(patchSize),[1 1 1]);
kern = cropCenterSize(lambdas,[7,7,7]);
kernDs = cellfunNonUniformOutput(@(x)cropCenterSize(x,[7,7,7]),gradLambdas);
kernD2s = cellfunNonUniformOutput(@(x)cropCenterSize(x,[7,7,7]),hessLambdas);
[bigLambdas,bigDLambdas,bigD2Lambdas] = bigLambda(domains,thetaInputs);

N = 1000;
LLRatioCoor1 = zeros(N,1);
LLRatioBkgnd = zeros(N,1);
LLRatioCoor1Dot   = zeros(N,1);
LLRatioBkgndDot   = zeros(N,1);
bkgndCoor = num2cell(round(size(kern)/2 + 2));
coor1 = num2cell(coor1);

parfor ii = 1:N
    display(ii);
    [sampledData,poissonNoiseOnly,cameraParams] = genMicroscopeNoise(bigLambdas{1});
    electronData = returnElectrons(sampledData,cameraParams);
    estimated = findSpotsStage1V2(electronData,kern,cameraVariance);
    [ gradients ] = calcGradientFilter(electronData,estimated,kern,kernDs,cameraVariance);
    % [ hessians ] = calcHessianFilter(sampledData,estimated,kern,kernDs,kernD2s,cameraVariance);
    [convergingKernel] = genConvergingKernel(kern);
    theDotProduct = convConveringKernel(gradients,convergingKernel);
    theDotProduct(theDotProduct<0) = 0;
    dotLLRatio = norm0to1(theDotProduct).*estimated.LLRatio;
    LLRatioCoor1(ii) = estimated.LLRatio(coor1{:});
    LLRatioBkgnd(ii) = estimated.LLRatio(bkgndCoor{:});
    LLRatioCoor1Dot(ii) = dotLLRatio(coor1{:});
    LLRatioBkgndDot(ii) = dotLLRatio(bkgndCoor{:});
end
% figure;histogram(LLRatioBkgndDot(:));hold on;histogram(LLRatioCoor1Dot(:));legend('bkgnddot','coor1dot');title('dot');
% figure;histogram(LLRatioBkgnd(:));hold on;histogram(LLRatioCoor1(:));legend('bkgnddot','coor1dot');title('normal');
rocdot = genROC('dot',LLRatioCoor1Dot,LLRatioBkgndDot);
rocLLR  = genROC('LLRatio',LLRatioCoor1,LLRatioBkgnd);
rocLLRsq  = genROC('LLRatio',LLRatioCoor1.^2,LLRatioBkgnd.^2);
figure;plot(1-rocdot.withoutTargetCDF,1-rocdot.withTargetCDF);hold on;plot(1-rocLLR.withoutTargetCDF,1-rocLLR.withTargetCDF);
hold on;plot(1-rocLLRsq.withoutTargetCDF,1-rocLLRsq.withTargetCDF);
legend('dot','llr','llrsq');
%% start building the iterative MLE for multi spot multi color
close all;
clear;
patchSize = [31 31 31];
sigmassq1 = [2,2,2];
sigmassq2 = [3,3,3];

% build the numeric multi emitter
[kern1,kern1Sep] = ndGauss(sigmassq1,patchSize);
[kern2,kern2Sep] = ndGauss(sigmassq2,patchSize);

domains = genMeshFromData(kern1);
kernObj1 = myPattern_Numeric(kern1);
kernObj2 = myPattern_Numeric(kern2);

centerCoor = getCenterCoor(size(kern1));
coor1 = centerCoor+3;
coor2 = centerCoor-3;
coor3 = centerCoor + [3 -3 0];
buildThetas1 = {{kernObj1,[3 coor1]},{kernObj1,[3 coor3]},{0}};
buildThetas2 = {{kernObj2,[3 coor2]},{0}};
Kmatrix      = [1 0.5;0.5 1];
thetaInputs2 = {buildThetas1,buildThetas2};
thetaInputs2 = {Kmatrix,thetaInputs2{:}};

% build max theta
buildMaxThetas1 = {[1 1 1 1],1};
buildMaxThetas2 = {[1 1 1 1],1};
kmatrixMax      = zeros(size(Kmatrix));
maxThetaInput = {buildMaxThetas1,buildMaxThetas2};
maxThetaInput = {kmatrixMax,maxThetaInput{:}};


[bigLambdas,~,~] = bigLambda(domains,thetaInputs2);
% plot3Dstack(bigLambdas{1},'text','measured channel 1');
% plot3Dstack(bigLambdas{2},'text','measured channel 2');

kern2 = threshPSF(kern2,0.015);
kern1 = cropCenterSize(kern1,size(kern2));

cameraVariance = ones(size(bigLambdas{1}));

[sampledData,~,cameraParams] = genMicroscopeNoise(bigLambdas);
[~,photonData] = returnElectrons(sampledData,cameraParams);
estimated = findSpotsStage1V2(photonData,{kern1,kern2},cameraVariance,'nonNegativity',false,'kMatrix',Kmatrix);
candidates = selectCandidates(estimated);

%% lets check how big of dataset i can use for my titanx video card
close all;
clear;
patchSize = [7 7 7];
sigmassq1 = [2,2,2];
sigmassq2 = [3,3,3];

% build the numeric multi emitter
[kern1,kern1Sep] = ndGauss(sigmassq1,patchSize);
[kern2,kern2Sep] = ndGauss(sigmassq2,patchSize);
[kern2,kern2Sep] = ndGauss(sigmassq2,patchSize);
dataset1 = rand(2048,2048,11);
dataset2 = rand(2048,2048,11);

cameraVariance = ones(size(dataset1));

% out of memory for 2048x2048x11 for 4 channels!!!!!
Kmatrix = [1 0.5 0.2 0.1; 0.1 1 0.5 0.2; 0.1 0.5 1 0.3; 0.1 0.2 0.5 1];
tic;
estimated = findSpotsStage1V2({dataset1,dataset2,dataset2,dataset2},{kern1Sep,kern2Sep,kern2Sep,kern1Sep},cameraVariance,'nonNegativity',false,'kMatrix',Kmatrix,'loadIntoGpu',true);
toc


%% %% do single color test first to see LLRatio is correct
%% do three color iterative multi spot fitting

%% just discovered that cross talk LLRatio, with all the careful calculation
% is equal to the naive LLRatio by adding them.  math is in my photos.
% confirmed numerically below. :-)  how beutiful.
close all;
clear;
patchSize = [19 19 19];
sigmassq1 = [2,2,2];
sigmassq2 = [3,3,3];

% build the numeric multi emitter
[kern1,kern1Sep] = ndGauss(sigmassq1,patchSize);
[kern2,kern2Sep] = ndGauss(sigmassq2,patchSize);

domains = genMeshFromData(kern1);
kernObj1 = myPattern_Numeric(kern1);
kernObj2 = myPattern_Numeric(kern2);

centerCoor = getCenterCoor(size(kern1));
buildThetas1 = {{kernObj1,[100 centerCoor+3]},{9}};
buildThetas2 = {{kernObj2,[100 centerCoor-3]},{6}};
Kmatrix      = [1 0.5;0.5 1];
% Kmatrix      = eye(size(Kmatrix));
thetaInputs2 = {buildThetas1,buildThetas2};
thetaInputs2 = {Kmatrix,thetaInputs2{:}};

% build max theta
buildMaxThetas1 = {[1 1 1 1],1};
buildMaxThetas2 = {[1 1 1 1],1};
kmatrixMax      = zeros(size(Kmatrix));
maxThetaInput = {buildMaxThetas1,buildMaxThetas2};
maxThetaInput = {kmatrixMax,maxThetaInput{:}};


% % generate true lambdas
% [trueLambdas1,~,~] = bigLambda(domains,{1,buildThetas1});
% [trueLambdas2,~,~] = bigLambda(domains,{1,buildThetas2});

% plot3Dstack(trueLambdas1{1},'text','ground truth 1');
% plot3Dstack(trueLambdas2{1},'text','ground truth 2');

[bigLambdas,~,~] = bigLambda(domains,thetaInputs2);
% plot3Dstack(bigLambdas{1},'text','measured channel 1');
% plot3Dstack(bigLambdas{2},'text','measured channel 2');

kern2 = threshPSF(kern2,0.015);
kern1 = cropCenterSize(kern1,size(kern2));
%  estimatedtruth = findSpotsStage1V2(bigLambdas,{kern1,kern2},ones(size(bigLambdas{1})),'kMatrix',Kmatrix);

cameraVariance = ones(size(bigLambdas{1}));
[sampledData,poissonNoiseOnly,cameraParams] = genMicroscopeNoise(bigLambdas);
[electronData,photonData] = returnElectrons(sampledData,cameraParams);
estimated = findSpotsStage1V2(photonData,{kern1,kern2},ones(size(bigLambdas{1})),'nonNegativity',false,'kMatrix',Kmatrix);
estimated1 = findSpotsStage1V2(photonData{1},kern1,ones(size(bigLambdas{1})),'nonNegativity',false);
estimated2 = findSpotsStage1V2(photonData{2},kern2,ones(size(bigLambdas{1})),'nonNegativity',false);

diagLLRatio = estimated1.LLRatio + estimated2.LLRatio;
plot3Dstack(cat(2,estimated.LLRatio,diagLLRatio));
[~,~,~,~,~,zLLRatio,~,~] = calcLLRatioManually2(photonData{1},photonData{2},kern1,kern2,estimated.A1{1},estimated.A1{2},estimated.B1{1},estimated.B1{2},estimated.B0{1},estimated.B0{2},cameraVariance,Kmatrix);
[~,~,~,~,~,zzLLRatio,~,~] = calcLLRatioManually2(photonData{1},photonData{2},kern1,kern2,estimated1.A1,estimated2.A1,estimated1.B1,estimated2.B1,estimated1.B0,estimated2.B0,cameraVariance,eye(size(Kmatrix)));


%% do single color test first to see LLRatio is correct
%% do three color iterative multi spot fitting
%
close all;
clear;
patchSize = [31 31 31];
sigmassq1 = [2,2,2];
sigmassq2 = [3,3,3];

% build the numeric multi emitter
[kern1,kern1Sep] = ndGauss(sigmassq1,patchSize);
[kern2,~] = ndGauss(sigmassq2,patchSize);

domains = genMeshFromData(kern1);
kernObj1 = myPattern_Numeric(kern1);
kernObj2 = myPattern_Numeric(kern2);

centerCoor = getCenterCoor(size(kern1));
coor1 = centerCoor+3;
coor2 = centerCoor-3;
buildThetas1 = {{kernObj1,[1 coor1]},{0}};
buildThetas2 = {{kernObj2,[1 coor2]},{0}};
Kmatrix      = [1 0.5;0.5 1];
thetaInputs2 = {buildThetas1,buildThetas2};
thetaInputs2 = {Kmatrix,thetaInputs2{:}};

% build max theta
buildMaxThetas1 = {[1 1 1 1],1};
buildMaxThetas2 = {[1 1 1 1],1};
kmatrixMax      = zeros(size(Kmatrix));
maxThetaInput = {buildMaxThetas1,buildMaxThetas2};
maxThetaInput = {kmatrixMax,maxThetaInput{:}};


% % generate true lambdas
% [trueLambdas1,~,~] = bigLambda(domains,{1,buildThetas1});
% [trueLambdas2,~,~] = bigLambda(domains,{1,buildThetas2});

% plot3Dstack(trueLambdas1{1},'text','ground truth 1');
% plot3Dstack(trueLambdas2{1},'text','ground truth 2');

[bigLambdas,~,~] = bigLambda(domains,thetaInputs2);
% plot3Dstack(bigLambdas{1},'text','measured channel 1');
% plot3Dstack(bigLambdas{2},'text','measured channel 2');

kern2 = threshPSF(kern2,0.015);
kern1 = cropCenterSize(kern1,size(kern2));
%  estimatedtruth = findSpotsStage1V2(bigLambdas,{kern1,kern2},ones(size(bigLambdas{1})),'kMatrix',Kmatrix);

cameraVariance = ones(size(bigLambdas{1}));

N = 8000;
LLRatioCoor1 = zeros(N,1);
LLRatioBkgnd = zeros(N,1);
bkgndCoor = num2cell([8 25 6]);
coor1 = num2cell(coor1);
coor2 = num2cell(coor2);

parfor ii = 1:N
    display(ii);
    [sampledData,~,cameraParams] = genMicroscopeNoise(bigLambdas);
    [~,photonData] = returnElectrons(sampledData,cameraParams);
    estimated = findSpotsStage1V2(photonData,{kern1,kern2},cameraVariance,'nonNegativity',false,'kMatrix',Kmatrix);
    LLRatioCoor1(ii) = estimated.LLRatio(coor1{:});
    LLRatioBkgnd(ii) = estimated.LLRatio(bkgndCoor{:});
end
figure;histogram(LLRatioBkgnd(:));hold on;histogram(LLRatioCoor1(:));legend('bkgnd-cross','coor1-cross');
genROC('asdf',LLRatioCoor1(:),LLRatioBkgnd(:));

% [zmodelSq1,zmodelSq2,zLL1,zLL0,zLL1SansDataSq,zLLRatio,crossTerms1,dataSqTerms] = calcLLRatioManually2(photonData{1},photonData{2},kern1,kern2,estimated.A1{1},estimated.A1{2},estimated.B1{1},estimated.B1{2},estimated.B0{1},estimated.B0{2},cameraVariance,Kmatrix);
%



%     [mmodelSq1a,mmodelSq2a,mLL1a,mLL0a,mLL1SansDataSqa,mLLRatioa] = calcLLRatioManually2(photonData{1},kern1,estimated1.A1,estimated1.B1,estimated1.B0,cameraVariance,[]);
%     [mmodelSq1b,mmodelSq2b,mLL1b,mLL0b,mLL1SansDataSqb,mLLRatiob] = calcLLRatioManually2(photonData{2},kern2,estimated2.A1,estimated2.B1,estimated2.B0,cameraVariance,[]);
% plot3Dstack(cat(2,trueLambdas1{1},trueLambdas2{1},estimated.A1{1},estimated.A1{2},estimated1.A1,estimated2.A1),'text','est A1 channel 1 then 2');


% plot3Dstack(cat(2,estimated.LLRatio,diagLLRatio));
% imtool3D(estimated.LLRatio-diagLLRatio);
% centerCoorCell = num2cell(centerCoor);
%
% [modelSq1,modelSq2,LL1,LL1SansDataSq,LLRatio] = calcLLRatioManually2(photonData{1},kern1,estimated1.A1,estimated1.B1,estimated1.B0,cameraVariance,Kmatrix);
%

%% do three color iterative multi spot fitting
close all;
clear;
patchSize = [31 31 31];
sigmassq1 = [2,2,2];
sigmassq2 = [3,3,3];
sigmassq3 = [4,4,4];
% build the numeric multi emitter
[kern1,kern1Sep] = ndGauss(sigmassq1,patchSize);
[kern2,kern2Sep] = ndGauss(sigmassq2,patchSize);
[kern3,kern2Sep] = ndGauss(sigmassq3,patchSize);
domains = genMeshFromData(kern1);
kernObj1 = myPattern_Numeric(kern1);
kernObj2 = myPattern_Numeric(kern2);
kernObj3 = myPattern_Numeric(kern3);

buildThetas1 = {{kernObj1,[7 8 15 16]},{kernObj1,[7 15 4 14]},{0}};
buildThetas2 = {{kernObj2,[7 5 12 13]},{0}};
buildThetas3 = {{kernObj3,[7 20 20 20]},{0}};
Kmatrix      = [1 0.5 0.5;0.2 1 0.5; 0.5 0.5 1];
% Kmatrix      = eye(size(Kmatrix));
thetaInputs2 = {buildThetas1,buildThetas2,buildThetas3};
thetaInputs2 = {Kmatrix,thetaInputs2{:}};

% build max theta
buildMaxThetas1 = {[1 1 1 1],[1 1 1 1],1};
buildMaxThetas2 = {[1 1 1 1],1};
buildMaxThetas3 = {[1 1 1 1],1};
kmatrixMax      = zeros(size(Kmatrix));
maxThetaInput = {buildMaxThetas1,buildMaxThetas2,buildMaxThetas3};
maxThetaInput = {kmatrixMax,maxThetaInput{:}};

kern3 = threshPSF(kern3,0.015);
kern2 = cropCenterSize(kern2,size(kern3));
kern1 = cropCenterSize(kern1,size(kern3));
% generate true lambdas
[trueLambdas1,~,~] = bigLambda(domains,{1,buildThetas1});
[trueLambdas2,~,~] = bigLambda(domains,{1,buildThetas2});
[trueLambdas3,~,~] = bigLambda(domains,{1,buildThetas3});
plot3Dstack(trueLambdas1{1},'text','ground truth 1');
plot3Dstack(trueLambdas2{1},'text','ground truth 2');
plot3Dstack(trueLambdas3{1},'text','ground truth 3');
[bigLambdas,~,~] = bigLambda(domains,thetaInputs2);
plot3Dstack(bigLambdas{1},'text','measured channel 1');
plot3Dstack(bigLambdas{2},'text','measured channel 2');
plot3Dstack(bigLambdas{3},'text','measured channel 3');
% estimatedtruth = findSpotsStage1V2(bigLambdas,kern1,ones(size(bigLambdas{1})),'kMatrix',Kmatrix);
[sampledData,poissonNoiseOnly,cameraParams] = genMicroscopeNoise(bigLambdas);
[electronData,photonData] = returnElectrons(sampledData,cameraParams);
estimated = findSpotsStage1V2(photonData,{kern1,kern2,kern3},ones(size(bigLambdas{1})),'kMatrix',Kmatrix,'nonNegativity',false);
plot3Dstack(estimated.A1{1},'text','est A1 channel 1');
plot3Dstack(estimated.A1{2},'text','est A1 channel 2');
plot3Dstack(estimated.A1{3},'text','est A1 channel 3');
max(estimated.A1{3}(:))
max(estimated.A1{2}(:))
max(estimated.A1{3}(:))
plot3Dstack(estimated.LLRatio,'text','LLRatio');
estimated1 = findSpotsStage1V2(photonData{1},kern1,ones(size(bigLambdas{1})),'nonNegativity',false);
estimated2 = findSpotsStage1V2(photonData{2},kern2,ones(size(bigLambdas{1})),'nonNegativity',false);
estimated3 = findSpotsStage1V2(photonData{3},kern3,ones(size(bigLambdas{1})),'nonNegativity',false);
plot3Dstack(cat(2,estimated.LLRatio,estimated1.LLRatio));
plot3Dstack(cat(2,estimated.LLRatio,estimated2.LLRatio));
plot3Dstack(cat(2,estimated.LLRatio,estimated3.LLRatio));

naiveLLRatio = estimated1.LLRatio + estimated2.LLRatio + estimated3.LLRatio;
plot3Dstack(cat(2,estimated.LLRatio,naiveLLRatio));


%% design gradient magnitude filter
patchSize = [21 21 21];
sigmassq1 = [2,2,2];
[kern1,~] = ndGauss(sigmassq1,patchSize);
domains = genMeshFromData(kern1);
cameraVariance = ones(size(kern1));
kernObj = myPattern_Numeric(kern1);
buildThetas = {{kernObj,[3 getCenterCoor(patchSize)]},{0}};
thetaInputs = {1,buildThetas};
[lambdas,gradLambdas,hessLambdas] = kernObj.givenThetaGetDerivatives(domains,getCenterCoor(patchSize),[1 1 1]);
kern = cropCenterSize(lambdas,[7,7,7]);
kernDs = cellfunNonUniformOutput(@(x)cropCenterSize(x,[7,7,7]),gradLambdas);
kernD2s = cellfunNonUniformOutput(@(x)cropCenterSize(x,[7,7,7]),hessLambdas);
[bigLambdas,bigDLambdas,bigD2Lambdas] = bigLambda(domains,thetaInputs);


[sampledData,poissonNoiseOnly,cameraParams] = genMicroscopeNoise(bigLambdas{1});
electronData = returnElectrons(sampledData,cameraParams);
estimated = findSpotsStage1V2(sampledData,kern,cameraVariance);


[ gradients ] = calcGradientFilter(sampledData,estimated,kern,kernDs,cameraVariance);
[ hessians ] = calcHessianFilter(sampledData,estimated,kern,kernDs,kernD2s,cameraVariance);
[convergingKernel] = genConvergingKernel(size(kern));
theDotProduct = convConveringKernel(gradients,convergingKernel);

myCoor = num2cell(getCenterCoor(patchSize));
myGradient = cellfun(@(x) x(myCoor{:}),gradients);
myHessian = cellfun(@(x) x(myCoor{:}),hessians);
myHessian\myGradient
plot3Dstack(estimated.LLRatio);
% gradients = cellfunNonUniformOutput(@gpuArray,gradients);
% hessians = cellfunNonUniformOutput(@gpuArray,hessians);
[updateX,updateY,updateZ] = calcNewtonUpdate(gradients,hessians);
newtonMag = sqrt(updateX.^2+updateY.^2+updateZ.^2);
newtonMag(isnan(newtonMag)) = 0;
plot3Dstack(newtonMag<0.002 & estimated.LLRatio>100);
%% design interpolating findspotstage1
patchSize = [19 21 25];
sigmassq1 = [1,2,3];
mux = 0:0.25:0.75;
muy = 0:0.25:0.75;
muz = 0:0.25:0.75;
kernCell = cell(numel(mux),numel(muy),numel(muz));
for ii = 1:numel(mux)
    for jj = 1:numel(muy)
        for kk = 1:numel(muz)
            [kernCell{ii,jj,kk},~] = ndGauss(sigmassq1,patchSize,[mux(ii),muy(jj),muz(kk)]);
        end
    end
end
[ estimated ] = findSpotsStage1V2Interpolate(kernCell{1},kernCell,ones(size(kernCell{1})));
plot3Dstack(estimated.LLRatio)
%%  checking llratio by arrayfun gpu
patchSize = [19 21 25];
sigmassq1 = [2,2,2];
[kern1,kern1Sep] = ndGauss(sigmassq1,patchSize);
domains = genMeshFromData(kern1);
kern1 = gpuArray(kern1);
cameraVariance = gpuArray(ones(size(kern1)));
estimated = findSpotsStage1V2(kern1,kern1,cameraVariance);

%% lets design iterative multi spot fitting
patchSize = [25 25 25];
sigmassq1 = [2,2,2];
sigmassq2 = [3,3,3];
% build the numeric multi emitter
[kern1,kern1Sep] = ndGauss(sigmassq1,patchSize);
[kern2,kern2Sep] = ndGauss(sigmassq2,patchSize);
domains = genMeshFromData(kern1);
kernObj1 = myPattern_Numeric(kern1);
kernObj2 = myPattern_Numeric(kern2);

buildThetas1 = {{kernObj1,[7 8 15 16]},{kernObj1,[7 15 4 14]},{1}};
buildThetas2 = {{kernObj2,[7 5 12 13]},{1}};
Kmatrix      = [1 0;0 1];
thetaInputs2 = {buildThetas1,buildThetas2};
thetaInputs2 = {Kmatrix,thetaInputs2{:}};

% build max theta
buildMaxThetas1 = {[1 1 1 1],[1 1 1 1],1};
buildMaxThetas2 = {[1 1 1 1],1};
kmatrixMax      = [0 0;0 0];
maxThetaInput = {buildMaxThetas1,buildMaxThetas2};
maxThetaInput = {kmatrixMax,maxThetaInput{:}};

kern2 = threshPSF(kern2,0.015);
kern1 = cropCenterSize(kern1,size(kern2));
% generate true lambdas
[trueLambdas1,~,~] = bigLambda(domains,{1,buildThetas1});
[trueLambdas2,~,~] = bigLambda(domains,{1,buildThetas2});
plot3Dstack(trueLambdas1{1},'text','ground truth 1');
plot3Dstack(trueLambdas2{1},'text','ground truth 2');
[bigLambdas,~,~] = bigLambda(domains,thetaInputs2);
plot3Dstack(bigLambdas{1},'text','measured channel 1');
plot3Dstack(bigLambdas{2},'text','measured channel 2');

% estimatedtruth = findSpotsStage1V2(bigLambdas,kern1,ones(size(bigLambdas{1})),'kMatrix',Kmatrix);
[sampledData,poissonNoiseOnly,cameraParams] = genMicroscopeNoise(bigLambdas);
electronData = returnElectrons(sampledData,cameraParams);
estimated = findSpotsStage1V2(electronData,{kern1,kern2},ones(size(bigLambdas{1})),'kMatrix',Kmatrix);
plot3Dstack(estimated.A1{1},'text','est A1 channel 1');
plot3Dstack(estimated.A1{2},'text','est A1 channel 2');
estimated1 = findSpotsStage1V2(electronData{1},kern1,ones(size(bigLambdas{1})));
estimated2 = findSpotsStage1V2(electronData{2},kern2,ones(size(bigLambdas{1})));
plot3Dstack(cat(2,estimated.LLRatio,estimated1.LLRatio,estimated2.LLRatio,estimated2.LLRatio+estimated1.LLRatio));
% i don't think current LLRatio is correct
sigmasqs = cell(size(bigLambdas));
for ii = 1:numel(bigLambdas)
    sigmasqs{ii} = ones(size(bigLambdas{ii}));
end

buildThetas1Er = {{kernObj1,[11.5 7 16 15]},{kernObj1,[7.6 15 3 13]},{0}};
buildThetas2Er = {{kernObj2,[12.5 6.5 13 12.3]},{0}};
Kmatrix      = [1 0.2;0.6 1];
thetaInputsEr = {buildThetas1Er,buildThetas2Er};
thetaInputsEr = {Kmatrix,thetaInputsEr{:}};
[ newtonBuild ] = newtonRaphsonBuild(maxThetaInput);
state = MLEbyIterationV2(bigLambdas,thetaInputsEr,sigmasqs,domains,{{maxThetaInput,4000},{newtonBuild,1000}},'doPlotEveryN',100);
%% for gfp and tdtomato on redGr filter cube i calculate the kmatrix to be
% greenTTL then cyanTTL for tdTomato then GFP . 20170220
clear;
Kmatrix = [1 0.3144; 0.0004 1];
greenTTL = '/mnt/btrfs/fcDataStorage/fcNikon/fcTest/20170216-check2ColorBleedThru/combinedData/green_red/BWY762_RG_6_w3-both(GreenTTL).tif';
cyanTTL = '/mnt/btrfs/fcDataStorage/fcNikon/fcTest/20170216-check2ColorBleedThru/combinedData/green_red/BWY762_RG_6_w3-both(CyanTTL).tif';
greenTTL = importStack(greenTTL);
cyanTTL = importStack(cyanTTL);



patchSize = [7 7 7];
sigmassq = [1,1,1];
% build the numeric multi emitter
[~,kern] = ndGauss(sigmassq,patchSize);


cameraCalibration2048x2048 = '/home/fchang/Dropbox/code/Matlab/fcBinaries/calibration-ID001486-CoolerAIR-ROI2048x2048-SlowScan-sensorCorrectionOFF-20161021.mat';
[greenTTL,cameraVars] = returnElectronsFromCalibrationFile(greenTTL,cameraCalibration2048x2048);
%greenTTL = gpuArray(greenTTL);
%kern = cellfunNonUniformOutput(@(x) gpuArray(x),kern);
%cameraVars = gpuArray(cameraVars);
clear findSpotsStage1V2;
tic;estimatedCyan = findSpotsStage1V2(cyanTTL,kern,cameraVars);toc

estimated2 = findSpotsStage1V2({greenTTL,cyanTTL},{kern,kern},cameraVars,'kMatrix',Kmatrix);
%% lets try spectral bleedthru on real data
cameraCalibration2048x2048 = '/Users/fchang/Documents/MATLAB/fcBinaries/calibration-ID001486-CoolerAIR-ROI2048x2048-SlowScan-sensorCorrectionOFF-20161021.mat';
patchSize = [7 7 7];
sigmassq = [1,1,1];
% build the numeric multi emitter
[~,kern] = ndGauss(sigmassq,patchSize);

bothFluors_greenTTL = '/Users/fchang/Dropbox/Public/testingREDGreenBleedthru/20170212-pinkel2Color-BWY762_RG/takeA3DStack/BWY762_RG_w3-both(GreenTTL).tif';
bothFluors_cyanTTL = '/Users/fchang/Dropbox/Public/testingREDGreenBleedthru/20170212-pinkel2Color-BWY762_RG/takeA3DStack/BWY762_RG_w3-both(CyanTTL).tif';
bothFluors_greenTTL = importStack(bothFluors_greenTTL);
bothFluors_cyanTTL = importStack(bothFluors_cyanTTL);

Kmatrix = [1 0.45; 0.4785 1];
estimated = findSpotsStage1V2({bothFluors_greenTTL,bothFluors_cyanTTL},kern,cameraCalibration2048x2048,Kmatrix);
%% lets check real multi spectral dataset
patchSize = [7 7 7];
sigmassq = [1,1,1];
% build the numeric multi emitter
kern = ndGauss(sigmassq,patchSize);
kern = kern / max(kern(:));
% first gfp only
gfp_greenTTL = '/Users/fchang/Dropbox/Public/testingREDGreenBleedthru/20170212-pinkel2Color-BWY769_GG/takeA3DStack/BWY769_GG_w3-both(GreenTTL).tif';
gfp_cyanTTL = '/Users/fchang/Dropbox/Public/testingREDGreenBleedthru/20170212-pinkel2Color-BWY769_GG/takeA3DStack/BWY769_GG_w3-both(CyanTTL).tif';
gfp_greenTTL = importStack(gfp_greenTTL);
gfp_cyanTTL = importStack(gfp_cyanTTL);
gfp_greenTTL_Filtered = findSpotsStage1V2(gfp_greenTTL,kern,ones(size(gfp_greenTTL)));
gfp_cyanTTL_Filtered = findSpotsStage1V2(gfp_cyanTTL,kern,ones(size(gfp_cyanTTL)));
gfp_cyanTTL_LLRatio = gfp_cyanTTL_Filtered.LLRatio;
gfp_cyanTTL_LLRatio(gfp_cyanTTL_LLRatio<0)=0;
threshVal = multithresh(gfp_cyanTTL_LLRatio(:));
selectorLLRatio = gfp_cyanTTL_LLRatio > threshVal;
selectorPOSCyan = gfp_cyanTTL_Filtered.A1 > 0;
selectorPOSGreen = gfp_greenTTL_Filtered.A1 >0;
selector = selectorLLRatio.*selectorPOSCyan.*selectorPOSGreen;


% thresh = multithresh(gfp_cyanTTL(:))*2;
% selector = gfp_cyanTTL>thresh;
hold on;scatter(gfp_cyanTTL_Filtered.A1(selector>0),gfp_greenTTL_Filtered.A1(selector>0),'MarkerFaceColor','g','MarkerEdgeColor','g','MarkerEdgeAlpha',.01,'MarkerFaceAlpha',.01);
% first tdtomato only
tdTomato_greenTTL = '/Users/fchang/Dropbox/Public/testingREDGreenBleedthru/20170212-pinkel2Color-BWY770_RR/takeA3DStack/BWY770_RR_w3-both(GreenTTL).tif';
tdTomato_cyanTTL = '/Users/fchang/Dropbox/Public/testingREDGreenBleedthru/20170212-pinkel2Color-BWY770_RR/takeA3DStack/BWY770_RR_w3-both(CyanTTL).tif';
tdTomato_greenTTL = importStack(tdTomato_greenTTL);
tdTomato_cyanTTL = importStack(tdTomato_cyanTTL);
% tdTomato_greenTTL = findSpotsStage1V2(tdTomato_greenTTL,kern,ones(size(tdTomato_greenTTL)));
% tdTomato_cyanTTL = findSpotsStage1V2(tdTomato_cyanTTL,kern,ones(size(tdTomato_cyanTTL)));

thresh = multithresh(tdTomato_greenTTL(:))*4;
selector = tdTomato_greenTTL>thresh;
hold on;
scatter(tdTomato_greenTTL(selector),tdTomato_cyanTTL(selector),'MarkerFaceColor','r','MarkerEdgeColor','r','MarkerEdgeAlpha',.003,'MarkerFaceAlpha',.003);

%% data with both datasets
bothFluors_greenTTL = '/Users/fchang/Dropbox/Public/testingREDGreenBleedthru/20170212-pinkel2Color-BWY762_RG/takeA3DStack/BWY762_RG_w3-both(GreenTTL).tif';
bothFluors_cyanTTL = '/Users/fchang/Dropbox/Public/testingREDGreenBleedthru/20170212-pinkel2Color-BWY762_RG/takeA3DStack/BWY762_RG_w3-both(CyanTTL).tif';
bothFluors_greenTTL = importStack(bothFluors_greenTTL);
bothFluors_cyanTTL = importStack(bothFluors_cyanTTL);
thresh = multithresh(bothFluors_cyanTTL(:))*2;
selector = bothFluors_cyanTTL>thresh;
hold on;
scatter(bothFluors_cyanTTL(selector),bothFluors_greenTTL(selector),'MarkerFaceColor','k','MarkerEdgeColor','k','MarkerEdgeAlpha',.1,'MarkerFaceAlpha',.1);


% lets try it on filtered datasets
bothFluors_greenTTL_F = findSpotsStage1V2(bothFluors_greenTTL,kern,ones(size(bothFluors_greenTTL)));
bothFluors_cyanTTL_F  = findSpotsStage1V2(bothFluors_cyanTTL,kern,ones(size(bothFluors_greenTTL)));
threshcyan = multithresh(bothFluors_cyanTTL_F.LLRatio(:));
threshgreen = multithresh(bothFluors_greenTTL_F.LLRatio(:));
selectorCyan = bothFluors_cyanTTL_F.LLRatio > threshcyan;
selectorGreen = bothFluors_greenTTL_F.LLRatio > threshgreen;
selector = selectorCyan.*selectorGreen.*(bothFluors_cyanTTL_F.A1>0).*(bothFluors_greenTTL_F.A1>0);
selector = selector>0;
scatter(datasample(bothFluors_cyanTTL(selector),1000),datasample(bothFluors_greenTTL(selector),1000),'k');
%% lets check multi dataset with multiple spots and see if i switch kmatrix order if it will affect calculation

patchSize = [19 21 25];
sigmassq = [6,6,6];
% build the numeric multi emitter
kern = ndGauss(sigmassq,patchSize);
kern = kern / max(kern(:));
domains = genMeshFromData(kern);
kernObj = myPattern_Numeric(kern);

buildThetas1 = {{kernObj,[11 5 12 13]},{kernObj,[7 15 4 14]},{5}};
buildThetas2 = {{kernObj,[12 4 4 13]},{10}};
buildThetas3 = {{kernObj,[8 15 12 10]},{6}};
Kmatrix      = [1 0.2 0.4;0.5,1, 0.2;0.6,0.1 1];
thetaInputs2 = {buildThetas1,buildThetas2,buildThetas3};
thetaInputs2 = {Kmatrix,thetaInputs2{:}};

[bigLambdas,~,~] = bigLambda(domains,thetaInputs2);
estimated = findSpotsStage1V2(bigLambdas,kern, ones(size(bigLambdas{1})),Kmatrix);
%% %% lets check multi dataset - it checks out for Kmatrix

patchSize = [19 21 25];
sigmassq = [6,6,6];
% build the numeric multi emitter
kern = ndGauss(sigmassq,patchSize);
kern = kern / max(kern(:));
domains = genMeshFromData(kern);
kernObj = myPattern_Numeric(kern);



buildThetas1 = {{kernObj,[11  10    11    13]},{5}};
buildThetas2 = {{kernObj,[2  10    11    13]},{10}};
Kmatrix      = [1 0.2;0.5,1];
thetaInputs2 = {buildThetas1,buildThetas2};
thetaInputs2 = {Kmatrix,thetaInputs2{:}};

[bigLambdas,~,~] = bigLambda(domains,thetaInputs2);

estimated = findSpotsStage1V2(bigLambdas,kern, ones(size(bigLambdas{1})),Kmatrix);


%% lets check a fill pipeline LL1 is tested
patchSize = [19 21 25];
sigmassq = [6,6,6];
% build the numeric multi emitter
kern = ndGauss(sigmassq,patchSize);
kern = kern / max(kern(:));
domains = genMeshFromData(kern);
kernObj = myPattern_Numeric(kern);


sigmasq  = ones(size(testData));

estimated1 = findSpotsStage1V2(kern+rand(size(kern)),kern,sigmasq);
estimated1 = findSpotsStage1V2({testData},kern,sigmasq);
estimated2 = findSpotsStage1V2({testData,testData,testData},kern,sigmasq);


%% lets check multi dataset

patchSize = [19 21 25];
sigmassq = [6,6,6];
% build the numeric multi emitter
kern = ndGauss(sigmassq,patchSize);
domains = genMeshFromData(kern);
kernObj = myPattern_Numeric(kern);



buildThetas1 = {{kernObj,[11 5.5 12.5 13.6]},{kernObj,[7 15.5 4.5 14.5]},{kernObj,[8.5 15.6 12.6 10.5]},{5.5}};
buildThetas2 = {{kernObj,[12 4.5 4.5 13]},{10}};
Kmatrix      = [1 0.2;0.2,1];
thetaInputs2 = {buildThetas1,buildThetas2};
thetaInputs2 = {Kmatrix,thetaInputs2{:}};
buildMaxThetas1 = {[2 1 1 1],[2 1 1 1],[2 1 1 1],2};
buildMaxThetas2 = {[2 1 1 1],2};
kmatrixMax      = [0 0;0 0];
maxThetaInput = {buildMaxThetas1,buildMaxThetas2};
maxThetaInput = {kmatrixMax,maxThetaInput{:}};

buildThetasTrue1 = {{kernObj,[10 5 12 13]},{kernObj,[6 15 5 15]},{kernObj,[8 15 12 10]},{5}};
buildThetasTrue2 = {{kernObj,[11 4 4 13]},{10}};
thetaInputsTrue = {buildThetasTrue1,buildThetasTrue2};
thetaInputsTrue = {Kmatrix,thetaInputsTrue{:}};



[bigLambdas,bigDLambdas,bigD2Lambdas] = bigLambda(domains,thetaInputsTrue);
sigmasqs = cell(size(bigLambdas));
for ii = 1:numel(bigLambdas)
    sigmasqs{ii} = ones(size(bigLambdas{ii}));
end

[ newtonBuild ] = newtonRaphsonBuild(maxThetaInput);
state = MLEbyIterationV2(bigLambdas,thetaInputs2,sigmasqs,domains,{{maxThetaInput,1000},{newtonBuild,1000}},'doPlotEveryN',100);

%% lets do sanity check with one dataset version
patchSize = [19 21 25];
sigmassq = [6,6,6];
% build the numeric multi emitter
kern = ndGauss(sigmassq,patchSize);
kern = kern / max(kern(:));
domains = genMeshFromData(kern);
kernObj = myPattern_Numeric(kern);

buildThetas1 = {{kernObj,[10.5 6.6 11.3 13.5]},{kernObj,[6 15 5.2 15]},{kernObj,[8 15 12.7 10]},{5.5}};
Kmatrix      = 1;
thetaInputsPerturb = {buildThetas1};
thetaInputsPerturb = {Kmatrix,thetaInputsPerturb{:}};

trueThetas = {{kernObj,[10 5 12 13]},{kernObj,[6 15 5 15]},{kernObj,[8 15 12 10]},{5}};
thetaInputsTrue = {trueThetas};
thetaInputsTrue = {Kmatrix,thetaInputsTrue{:}};
buildMaxThetas = {0,{[2 1 1 1],[2 1 1 1],[2 1 1 1],2}};


[bigLambdas,bigDLambdas,bigD2Lambdas] = bigLambda(domains,thetaInputsTrue);
sigmasqs = cell(size(bigLambdas));
for ii = 1:numel(bigLambdas)
    sigmasqs{ii} = ones(size(bigLambdas{ii}));
end
[ newtonBuild ] = newtonRaphsonBuild(buildMaxThetas);
state = MLEbyIterationV2(bigLambdas,thetaInputsPerturb,sigmasqs,domains,{{buildMaxThetas,1000},{newtonBuild,1000}},'doPlotEveryN',100);

%% check against MLEbyIteration original
%(data,theta0,readNoise,domains,varargin)
% [x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak] = deal(theta{:});
posx = 5;
posy = 12.1;
posz = 13;
sigmax = 6;
sigmay = 6;
sigmaz = 6;
amp = 10;
back = 5;
theta0 = [posx,posy,posz,sigmax,sigmay,sigmaz,amp,back];
theta0 = num2cell(theta0);
% flatten domains
datas = bigLambdas{1}(:);
state = MLEbyIteration(bigLambdas{1}(:),theta0,sigmasqs{1}(:),cellfunNonUniformOutput(@(x) x(:),domains),'type',2,'doPlotEveryN',10);


%% lets check mle by iteration v2

patchSize = [19 21 25];
sigmassq = [6,6,6];
% build the numeric multi emitter
kern = ndGauss(sigmassq,patchSize);
domains = genMeshFromData(kern);
kernObj = myPattern_Numeric(kern);



buildThetas1 = {{kernObj,[10.1 5 12.1 13]},{kernObj,[6 15 5 15]},{kernObj,[8 15 12 10]},{5}};
buildThetas2 = {{kernObj,[5 12 10.1 13]},{10}};
Kmatrix      = [1 0.2;0.5,1];

thetaInputs2 = {buildThetas1,buildThetas2};
thetaInputs2 = {Kmatrix,thetaInputs2{:}};
%% lets test big lambda

patchSize = [19 21 25];
sigmassq = [6,6,6];
% build the numeric multi emitter
kern = ndGauss(sigmassq,patchSize);
domains = genMeshFromData(kern);
kernObj = myPattern_Numeric(kern);


% spot in dataset 1
thetas1 = {[10 5 12 13],[6 15 5 15],[8 15 12 10]};
bkgnd1 = 5;
% spot in dataset 2
thetas2 = {[5 12 10 13]};
bkgnd2 = 10;

Kmatrix = [1 0.2;0.5,1];

buildThetas1 = {};
buildMaxThetas1 = {};
for ii = 1:numel(thetas1)
    buildThetas1{end+1} = {kernObj,thetas1{ii}};
    buildMaxThetas1{end+1} = [2 1 1 1];
end
buildThetas1{end+1} = {bkgnd1};
buildMaxThetas1{end+1} = 2;

buildThetas2 = {};
buildMaxThetas2 = {};
for ii = 1:numel(thetas2)
    buildThetas2{end+1} = {kernObj,thetas2{ii}};
    buildMaxThetas2{end+1} = [2 1 1 1];
end
buildThetas2{end+1} = {bkgnd2};
buildMaxThetas2{end+1} = 2;

thetaInputs = {buildThetas1,buildThetas2};
maxThetaInputs = {buildMaxThetas1,buildMaxThetas2};
maxKmatrix = [0 0; 0 0];
thetaInputs = {Kmatrix,thetaInputs{:}};
maxThetaInputs = {maxKmatrix,maxThetaInputs{:}};
[bigLambdas,bigDLambdas,bigD2Lambdas] = bigLambda(domains,thetaInputs);
N = 100;

sigmasqs = cell(size(bigLambdas));
for ii = 1:numel(bigLambdas)
    sigmasqs{ii} = ones(size(bigLambdas{ii}));
end

state = MLEbyIterationV2(bigLambdas,thetaInputs2,sigmasqs,domains,{{maxThetaInputs,N}});
%% testing color unmixing
% need to test, but will work on n color unmixing first
cameraVariance = ones(size(bigLambdas{1}));
spotKern = threshPSF(kern,0.0015);
estimated1 = findSpotsStage1(bigLambdas{1},spotKern,cameraVariance);
estimated2 = findSpotsStage1(bigLambdas{2},spotKern,cameraVariance);
invKmatrix = inv(Kmatrix);

output1 = zeros(size(bigLambdas{1}));
output2 = zeros(size(bigLambdas{1}));
for ii = 1:numel(bigLambdas{1})
    test = invKmatrix*[estimated1.A1(ii);estimated2.A1(ii)];
    output1(ii) = test(1);
    output2(ii) = test(2);
end

%% build a single spot and compare with mathematica
% it matches with rms error of 10e-18, note i need to permute the
% dimensions [2 3 1] to match with mathematica
patchSize = [19 21 25];
sigmaSq   = [6,6,6];
testTheta = [9 8 7];
k = 1;
A = 1;
B = 0;
domains = genMeshFromData(ones(patchSize));
analyticThetaNaked = [testTheta,sigmaSq,A,B];
analyticLambda = k*lambda_single3DGauss(num2cell(analyticThetaNaked),domains,[1 1 1 0 0 0 0 0 ],0);
analyticLambda = permute(analyticLambda,[2 3 1]);
save('~/Desktop/matlabLambda','analyticLambda');

%% build a multi spot and compare with mathematica
% for mathematica need to permute [2 3 1]
% it matches 10e-18 when the numeric spot pattern does not move.
% when the pattern moves 0.5 pixels the rms error is 0.00324052
% when the pattern moves in the wrong 0.5 direction the rms error is 0.0261456


patchSize = [19 21 25];
sigmassq = [6,6,6];
% [amplitude x y z]
thetas = {[10 10 12 13],[6 15 11 15],[8 9 12 10]};
bkgnd = 5;
k = 0.2;

% build the numeric multi emitter
kern = ndGauss(sigmassq,patchSize);
domains = genMeshFromData(kern);
kernObj = myPattern_Numeric(kern);
buildThetas = {k};
buildMaxThetas = {1};
for ii = 1:numel(thetas)
    buildThetas{end+1} = {kernObj,thetas{ii}};
    buildMaxThetas{end+1} = [1 1 1 1];
end
buildThetas{end+1} = {bkgnd};
buildMaxThetas{end+1} = 1;
[genLambda,genDLambda,genD2Lambda] = littleLambda(domains,buildThetas,buildMaxThetas);


% for mathematica convert scalar to scalar*ones(sizeData)
for ii = 1:numel(genDLambda)
    if isscalar(genDLambda{ii})
        genDLambda{ii} = genDLambda{ii}*ones(patchSize);
    end
end

for ii = 1:numel(genD2Lambda)
    if isscalar(genD2Lambda{ii})
        genD2Lambda{ii} = genD2Lambda{ii}*ones(patchSize);
    end
end

% for mathematica do corrections on dimension order
genLambda = permute(genLambda,[2 3 1]);
genDLambda = cellfunNonUniformOutput(@(x) permute(x,[2 3 1]),genDLambda);
genD2Lambda = cellfunNonUniformOutput(@(x) permute(x,[2 3 1]),genD2Lambda);

save('~/Desktop/genLambda.mat','genLambda');
save('~/Desktop/genDLambda.mat','genDLambda');
save('~/Desktop/genD2Lambda.mat','genD2Lambda');

%% build a spot and generating its derivatives
patchSize = [21 21 21];
kern = ndGauss([6,6,6],patchSize);
kernObj = myPattern_Numeric(kern);
domains = genMeshFromData(kern);
testTheta = [17 18 10];
maxThetas = [1 1 1];
plot3Dstack(kernObj.givenTheta(domains,testTheta))
[lambdas,gradLambdas,hessLambdas] = kernObj.givenThetaGetDerivatives(domains,testTheta,maxThetas);
analyticThetaNaked = [testTheta,6,6,6 10 5];
analyticLambda = lambda_single3DGauss(num2cell(analyticThetaNaked),domains,ones(size(analyticThetaNaked)),0);
plot3Dstack(analyticLambda)
NDrms(lambdas,analyticLambda)
analyticDLambda = lambda_single3DGauss(num2cell(analyticThetaNaked),domains,[1 1 1 0 0 0 0 0 ],1);
analyticD2Lambda = lambda_single3DGauss(num2cell(analyticThetaNaked),domains,[1 1 1 0 0 0 0 0],2);
analyticDLambda = analyticDLambda(logical([1 1 1 0 0 0 0 0]));
analyticD2Lambda = analyticD2Lambda(logical([1 1 1 0 0 0 0 0]'*[1 1 1 0 0 0 0 0]));
NDrms(gradLambdas{1},analyticDLambda{1})
direction = {'x','y','z'};
for ii = 1:numel(gradLambdas)
    plot3Dstack(cat(1,gradLambdas{ii},analyticDLambda{ii}),'cbar',true,'projectionFunc',@maxextremumproj,'text',['(left: numeric, right: analytic 3D gaussian) d/d' direction{ii}]);
end

for ii = 1:numel(hessLambdas)
    [xx,yy] = ind2sub(size(hessLambdas),ii);
    plot3Dstack(cat(2,hessLambdas{ii},analyticD2Lambda{ii}),'cbar',true,'projectionFunc',@maxextremumproj,'text',['(left: numeric, right: analytic 3D gaussian) d2/d' direction{xx} 'd' direction{yy}]);
end
plot3Dstack(cat(2,lambdas,analyticLambda),'cbar',true,'projectionFunc',@maxextremumproj,'text','(left: numeric, right: analytic 3D gaussian) lambdas');


% multi spots
theta1 = [10 1.2 1 5.5];
theta2 = [6 5 5.87 2.2];
theta3 = [8 4.1 4.6 3.1];
bkgnd = 5;
k = 1;
buildThetas = {k,{kernObj,theta1},{kernObj,theta2},{kernObj,theta3},{bkgnd}};
% buildmaxthetas will always return dA
buildMaxThetas = {1,[1 1 1 1],[1 1 1 1],[1 1 1 1], 1};
[genLambda,genDLambda,genD2Lambda] = littleLambda(domains,buildThetas,buildMaxThetas);

%% check little lambda for correctness

% for mathematica need to permute [2 3 1]
patchSize = [19 21 25];
sigmassq = [6,6,6];

% [amplitude x y z]
thetas = {[10 11 11 11],[6 11 11 11],[8 11 11 11]};
bkgnd = 5;
k = 0.2;

% build the numeric multi emitter
kern = ndGauss(sigmassq,patchSize);
domains = genMeshFromData(kern);
kernObj = myPattern_Numeric(kern);
buildThetas = {k};
buildMaxThetas = {1};
for ii = 1:numel(thetas)
    buildThetas{end+1} = {kernObj,thetas{ii}};
    buildMaxThetas{end+1} = [1 1 1 1];
end
buildThetas{end+1} = {bkgnd};
buildMaxThetas{end+1} = 1;
[genLambda,genDLambda,genD2Lambda] = littleLambda(domains,buildThetas,buildMaxThetas);

% build analytic multi emitter
analyticLambda = 0;
for ii = 1:numel(thetas)
    analyticThetaNaked = [thetas{ii}(2:end) sigmassq(:)' thetas{ii}(1) 0];
    analyticLambda = analyticLambda + lambda_single3DGauss(num2cell(analyticThetaNaked),domains,ones(size(analyticThetaNaked)),0);
end
analyticLambda = analyticLambda + bkgnd;
analyticLambda = k*analyticLambda;

% build analytic gradient multi emitter
analyticD = {};

analyticD{1} = analyticLambda/k;
for ii = 1:numel(thetas)
    currAmp =thetas{ii}(1);
    currXYZ = thetas{ii}(2:end);
    analyticThetaNaked = [currXYZ sigmassq(:)' 1 0];
    currLambda = lambda_single3DGauss(num2cell(analyticThetaNaked),domains,ones(size(analyticThetaNaked)),0);
    currDs = lambda_single3DGauss(num2cell(analyticThetaNaked),domains,ones(size(analyticThetaNaked)),1);
    
    % dlambda/da
    analyticD{end+1} = k*currLambda;
    analyticD = appendToCellOrArray(analyticD,cellfunNonUniformOutput(@(x) x*currAmp*k,currDs(1:3)));
end
analyticD{end+1} = k;

for ii = 1:numel(genDLambda)-1
    plot3Dstack(cat(2,genDLambda{ii},analyticD{ii}),'projectionFunc',@maxextremumproj)
end





