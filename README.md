#fcTools by frederick chang (fchang@fas.harvard.edu)
fctools consists of a set of matlab tools that i use for my research:
- 3d spot detection
- segmentation
- nD experiment processing
- microscope control




##rules of the code:
- template function that allows parameter adjustment and passing to subfunctions.

  ```Matlab
function output = funcName(varargin)
%FUNCNAME does this and that.
% 
% arg1:     arg1 is this
% arg2:     arg2 is that
% 
% [notes] - a heads up for the user
% 
% [param cascade] -> subFunc1
%                 -> subFunc2
 
%--parameters--------------------------------------------------------------
params.default1     = 1;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

subFunc1Params.addStuff = 1;
subFunc1(updateParams(params,subFunc1Params)); 
% or
subFunc1(updateParams(params,'param1',1));
% or 
params.addParams1 = 1;
subFunc1(params{:});
% or
subFunc1('name',value,params)
end
```

- complicated functions with sub-functions should be organized by the following folder hierarchy.

  ```Matlab
./doFunc
./doFunc/helper
./doFunc/testFunctions
./doFunc/doFunc.m
```

##processing files:
- For processing large batches of data, like a list of image files I will follow the following convetion.
  * raw data is stored in

    ```           
    .../fcData/.../data1_t1.tif
    ```

  * processed data in which a function is applied to a single data1_t1.tif is mirrored

    ```
    .../fcProcessed/.../funcName(paramHash,pathHash)/funcName(data1_t1.tif).ext
    ```

  * the parameter hash keeps different function calls with different parameter and a hash for different datalists saved in different folders.  even better would to automatically glob the list of paths so the user knows what is in there.
  * processed in data in which a function is applied to a plurality of data1_t1,data1_t2,...,data1_tn

    ```
    .../fcProcessed/.../funcName-paramhash/funcName(data1_t[1-n].tif).ext
    ```

  * this convention below uses the filesystem as a data holder rather than specifying the data holder apriori (such as hdf5) because the filesystem can grow organically.
  * only limitation is that filenames need to be less than 255 chars.
  * so if a func grows too big, like func(input1,input2,....inputn) > 255 characters, just hash the input to be func(inputhash)
  * every operation below is about processing a list of files then save as an output or list of outputs that mirror the list of inputs.  
      dominant use case 
    * `{list of inputs}n -func(params)-> {list of outputs}n  // like filtering`
        * save as func(input_i).ext
    * {list of inputs}n -func(params)-> 1 output // like segmentation
        
    * {list of inputs}n -func(params)-> {list of outputs}m // like extracting cells

    * {list of inputs}n, {list of inputs}m , ... -> func(params) -> {list of outputs}a, {list of ouputs}b
        * /func(paramHash,pathsHash)/func_outputa({list of inputs}n,{list of inputs}m)
        * /func(paramHash,pathsHash)/func_outputb({list of inputs}n,{list of inputs}m)
        * ...
    * each operation returns to workspace:
        * inputs: {{list of inputs}n,...} (ordered)
        * outputs: {{list of outputs}m,...} (ordered)
        * output function: myFunc
        * parameters: myParams

```Matlab
% paths were dropped for clariy
%%==example data lists=====================================================
w1 >> {data-w1-t1.tif,data-w1-t2.tif,data-w1-t3.tif}
w2 >> {data-w2-t1.tif,data-w2-t2.tif,data-w2-t3.tif}
%%==example processed lists================================================
genQPM.input = {data-w1-t1.tif,data-w1-t2.tif,data-w1-t3.tif}
genQPM.output = {genQPM(data-w1-t1),genQPM(data-w1-t2),genQPM(data-w1-t3)}

spotDetection.input = {data-w2-t1.tif,data-w2-t2.tif,data-w2-t3.tif}
spotDetection.output = {
                        {fcSpotDetection_ThetaMLE(data-w2-t1),...},
                        {fcSpotDetection_A1(data-w2-t1),...},
                        {...},{...},{...}
                        };

alignStage.input = {genQPM(data-w1-t1),genQPM(data-w1-t2),genQPM(data-w1-t3)}
alignStage.output = {{alignStage(genQPM(data-w1-t1)),...},{alignStage(paramHash).mat}}

alignChannels.input = {{data-w1-t1,...},
                       {data-w2-t1,...},    
                       {alignStage(genQPM(data-w1-t1)),...},
                       {fcSpotDetection_A1(data-w2-t1),...},...};
alignChannels.output = {{alignChannels(data-w1-t1),...,alignChannels(paramHash4,pathsHash1).mat},   
                        {...},{...},...};

alignSpotDetection.input = {{fcSpotDetection_ThetaMLE(data-w2-t1),...}}
alignSpotDetection.output = {{alignSpotDetection(fcSpotDetection_ThetaMLE(data-w2-t1)),...}}

yeastSeg.input = {alignChanenls.output{the one with QPM}};
yeastSeg.output = {{yeastSeg(alignChannels(alignStage(genQPM(data-w1-t1)))).tif, ... , yeastSeg(paramHash6,pathsHash8).mat}};

extractCells.input = {alignChannels.output},
                       ...};
extractCells.output = {{extractCell_1(alignChannels(data-w1-t1)),...},
                       {extractCell_1(alignChannels(data-w2-t1)),...},
                        ...
                       {extractCell_2(alignChannels(data-w1-t1)),...},
                        ...};

extractThetaMLE.input = {spotDetection.output{the one with ThetaMLE},
                         yeastSeg.output};
extractThetaMLE.output = {{extractThetaMLE_1(fcSpotDetection_ThetaMLE(data-w2-t1)).mat ...},
                          {extractThetaMLE_2(fcSpotDetection_ThetaMLE(data-w2-t1)).mat ...},    
                          ....}


```

```Matlab
%%==example data===========================================================

.../fcData../data-w1-t1.tif
.../fcData../data-w1-t2.tif
.../fcData../data-w1-t3.tif

.../fcData../data-w2-t1.tif
.../fcData../data-w2-t2.tif
.../fcData../data-w2-t3.tif

%%==example processed data=================================================

%--processing phase-------------------------------------------------------- 
.../fcProcessed/.../genQPM(paramHash1,pathsHash1)/genQPM(data-w1-t1).fits ...

%--processing spot detection on entire FOV---------------------------------
.../fcProcessed/.../fcSpotDetection(paramHash2,pathsHash2)/fcSpotDetection_ThetaMLE/fcSpotDetection_ThetaMLE(data-w2-t1).mat ...
.../fcProcessed/.../fcSpotDetection(paramHash2,pathsHash2)/fcSpotDetection_A1/fcSpotDetection_A1(data-w2-t1).fits ...
.../fcProcessed/.../fcSpotDetection(paramHash2,pathsHash2)/fcSpotDetection_LLRatio/fcSpotDetection_LLRatio(data-w2-t1).fits ...
.../fcProcessed/.../fcSpotDetection(paramHash2,pathsHash2)/fcSpotDetection_Conv/fcSpotDetection_Conv(data-w2-t1).fits ...

%--correct stage movement in one channel-----------------------------------
.../fcProcessed/.../alignStage(paramHash3,pathsHash3)/alignStage(genQPM(data-w1-t1)).fits ... alignStage(paramHash).mat

%--do channel alignment on fov---------------------------------------------
.../fcProcessed/.../alignChannels(paramHash4,pathsHash1)/alignChannels(data-w1-t1).tif ... alignChannels(paramHash4,pathsHash1).mat
.../fcProcessed/.../alignChannels(paramHash4,pathsHash2)/alignChannels(data-w2-t1).tif ... alignChannels(paramHash4,pathsHash2).mat
.../fcProcessed/.../alignChannels(paramHash4,pathsHash3)/alignChannels(alignStage(genQPM(data-w1-t1))).tif ... alignChannels(paramHash4,pathsHash3).mat
.../fcProcessed/.../alignChannels(paramHash4,pathsHash4)/alignChannels(fcSpotDetection_A1(data-w2-t1)).fits ... alignChannels(paramHash4,pathsHash4).mat
.../fcProcessed/.../alignChannels(paramHash4,pathsHash5)/alignChannels(fcSpotDetection_LLRatio(data-w2-t1)).fits ... alignChannels(paramHash4,pathsHash5).mat
.../fcProcessed/.../alignChannels(paramHash4,pathsHash6)/alignChannels(fcSpotDetection_Conv(data-w2-t1)).fits ... alignChannels(paramHash4,pathsHash6).mat

%--do spot detection alignment---------------------------------------------
.../fcProcessed/.../alignSpotDetection(paramHash5,pathsHash7)/.../alignSpotDetection(fcSpotDetection_ThetaMLE(data-w2-t1)).mat ...

%--segmentation on phase---------------------------------------------------
.../fcProcessed/.../yeastSeg(paramHash6,pathsHash8)/yeastSeg(alignChannels(alignStage(genQPM(data-w1-t1)))).tif ... yeastSeg(paramHash6,pathsHash8).mat

%--extract cells given segmentation data-----------------------------------
.../fcProcessed/.../extractCells(paramHash9,pathsHash9)/extractCells_1/extractCell_1(alignChannels(data-w1-t1)).fits ...
.../fcProcessed/.../extractCells(paramHash9,pathsHash10)/extractCells_1/extractCell_1(alignChannels(data-w2-t1)).fits ...
.../fcProcessed/.../extractCells(paramHash9,pathsHash11)/extractCells_1/extractCell_1(alignChannels(alignStage(genQPM(data-w1-t1)))).fits ...
.../fcProcessed/.../extractCells(paramHash9,pathsHash12)/extractCells_1/extractCell_1(fcSpotDetection_A1(data-w2-t1)).fits ...
.../fcProcessed/.../extractCells(paramHash9,pathsHash13)/extractCells_1/extractCell_1(fcSpotDetection_LLRatio(data-w2-t1)).fits ...
.../fcProcessed/.../extractCells(paramHash9,pathsHash14)/extractCells_1/extractCell_1(fcSpotDetection_Conv(data-w2-t1)).fits ...

.../fcProcessed/.../extractCells(paramHash9,pathsHash9)/extractCells_2/extractCell_2(alignChannels(data-w1-t1)).fits ...
.../fcProcessed/.../extractCells(paramHash9,pathsHash10)/extractCells_2/extractCell_2(alignChannels(data-w2-t1)).fits ...
.../fcProcessed/.../extractCells(paramHash9,pathsHash11)/extractCells_2/extractCell_2(alignChannels(alignStage(genQPM(data-w1-t1)))).fits ...
.../fcProcessed/.../extractCells(paramHash9,pathsHash12)/extractCells_2/extractCell_2(fcSpotDetection_A1(data-w2-t1)).fits ...
.../fcProcessed/.../extractCells(paramHash9,pathsHash13)/extractCells_2/extractCell_2(fcSpotDetection_LLRatio(data-w2-t1)).fits ...
.../fcProcessed/.../extractCells(paramHash9,pathsHash14)/extractCells_2/extractCell_2(fcSpotDetection_Conv(data-w2-t1)).fits ...

...
%--extract thetaMLE given segmentation data--------------------------------
.../fcProcessed/.../extractThetaMLE(paramHash10,pathsHash15)/extractThetaMLE_1/extractThetaMLE_1(fcSpotDetection_ThetaMLE(data-w2-t1)).mat ...

.../fcProcessed/.../extractThetaMLE(paramHash10,pathsHash15)/extractThetaMLE_2/extractThetaMLE_2(fcSpotDetection_ThetaMLE(data-w2-t1)).mat ...

...
%--segment nuclear fuzz for each cell--------------------------------------
.../fcProcessed/.../segmentNucFuzz(params11,pathsHash16)/extractCells_1/segmentNucFuzz(extractCell_1(fcSpotDetection_Conv(data-w2-t1))).tif ...

.../fcProcessed/.../segmentNucFuzz(params11,pathsHash16)/extractCells_2/segmentNucFuzz(extractCell_2(fcSpotDetection_Conv(data-w2-t1))).tif ...

...
%--segment nuclear fuzz for entire fov-------------------------------------
.../fcProcessed/.../segmentNucFuzz(params12,pathsHash17)/segmentNucFuzz(alignChannels(fcSpotDetection_Conv(data-w2-t1))).tif ...

%--do spot tracking on each cell-------------------------------------------
% many inputs to one file will either take the first file as the name or do something like t[1-1-100]
.../fcProcessed/.../spotTracking(paramHash12,pathsHash17)/extractCells_1/spotTracking(extractThetaMLE_1(fcSpotDetection_ThetaMLE(data-w2-t[1-3]))).mat 

.../fcProcessed/.../spotTracking(paramHash12,pathsHash17)/extractCells_2/spotTracking(extractThetaMLE_2(fcSpotDetection_ThetaMLE(data-w2-t[1-3]))).mat 

...
%--find replication timing for each cell-----------------------------------
.../fcProcessed/.../findRepTiming(paramHash13,pathsHash18)/extractThetaMLE_1/findRepTiming(extractThetaMLE_1(fcSpotDetection_ThetaMLE(data-w2-t[1-3]))).mat

.../fcProcessed/.../findRepTiming(paramHash13,pathsHash18)/extractThetaMLE_2/findRepTiming(extractThetaMLE_2(fcSpotDetection_ThetaMLE(data-w2-t[1-3]))).mat

...
%--plot data for each cell-------------------------------------------------

%%=========================================================================
```


## datastructures used in the code:
- spotParamStruct is a container that is used to hold various parameters of a spot.  Depending how it is used, not all parameters are populated.
this container should be able to handle different fits, such as 0 spots, 1 spot, 2 spots etc.
  * for synthetic spot generation it is organized like so:
{spotParamStruct1,spotParamStruct2,...}
each struct corresponding to each synthetic spot.
  * However, for detecting spots in a given dataset i for timepoint i, I need to account for testing multiple hypothesis for a given patch/candidate of data, whether it is 0 spot, 1 spot, 2 spots, etc.
so it will be:
{{spotParamStructFor0Spots_candidate1,spotParamStructFor1Spots_candidate1,spotParamStructFor2Spots_candidate1,...},{spotParamStructFor0Spots_candidate2,spotParamStructFor1Spots_candidate2,spotParamStructFor2Spots_candidate2,...},...}

  a sample spot param data structure will be subsets of the following:

  ```Matlab
spotParamStruct.xp          = x position in the specimen plane (m)
spotParamStruct.yp          = y position in the specimen plane (m)
spotParamStruct.zp          = z position in the specimen plane (m)

spotParamStruct.xPixel1      = x position in pixel units
spotParamStruct.yPixel1      = y position in pixel units
spotParamStruct.zPixel1      = z position in slice number units
spotParamStruct.amp1        = value of peak amplitude given 1 spot
spotParamStruct.bak1        = value of the background given 1 spot

spotParamStruct.xPixel2      = x position in pixel units
spotParamStruct.yPixel2      = y position in pixel units
spotParamStruct.zPixel2      = z position in slice number units
spotParamStruct.amp2        = value of peak amplitude given 2 spot
spotParamStruct.bak2        = value of the background given 2 spot

spotParamStruct.logLike    = log Likelihood 

spotParamStuct.bak0         = value of the background given background only model (0 spot)
```





## usage notes:
* 3D/ND spot detection protocols
for ideal use case (this fulfills MLE):
  1. calibrate camera and acquire pixel dependent {offset_i, gain_i, variance_i}
  2. capture an experimental image (ADU units)
  3. transform image (ADU units) to electrons
  4. apply stage one MLE 

* for just-get-it-done case (empirically works well):
  1. capture image (in ADU units)
  2. apply stage one MLE (intensity parameters are in ADU units)

* how to organize stage two functions so multiple emitters can be solved


## programming notes:



## diary of progress:
* 20160626 __processing__ a bunch of files need to be figured out since this type of computing will be common.  I think something like applyFuncToListOfFiles() would be good, but i need to figure out how to systematically save the outputs as well.  Perhaps the function you pass has instructions on how to save its own output?  no, this makes it not so general purpose.  how bout you pass the saving function as well? so then the user can select a generic saving function that works most of the time, and if need be make a custom saving function for special cases.  yup.  this is how i will do it: applyFuncTo_ListOfFiles(ListOfFiles,@myFunc,{parameterListForMyFunc},@mySavingDirections,{paramterListForSavingDirections})
* 20160406 __gradient ascent__ is more stable with normalized gradient steps.  so the gradient gives the direction to go, and step size provides how much to go.  works better at all SNR regimes.
* 20160322 __negative data values__ need to be checked against the log likelihoods? so far it seems to work without explicit checking, so revist in the future.
* 20160321 __most sensitive detection__ is minimizing the variance of the estimated paremeters (provided by the likelihood) and finding spots by the log likelihood ratio between 1 spot and 0 spot model.  finding MLE of A and B can be done with fourier methods but the likelihood is truncated to make it amenable.  i wrote a function nlfitler3d that can find an estimate MLE{A,B} for every position in the dataset using the full likelihood model and then return the full log likelihood ratio.  at low snr regimes this can be helpful.  
* 20160302 __log likelihood__ with full poisson*gaussian can probably be amenable if the LL(d,lambda) is precalculated then interpolated by griddedInterpolant class
* 20160224 __gradient ascent__ actually doesn't really need inplace operations since memory allocation is very fast in 2015b.  (so not a big deal), but anonymous functions 
* 20160220 __gradient ascent__ should take advantage of inplace operations since I shouldn't allocate memory for every step.  
* 20160220 __gradient ascent__ should recieve nd-data flattened as column major vectors since the gradient calculation is a dot product anyways.    
* 20160220 __thresholding likelihoood__ can be filtered by the minimal connected volume because there is a characteristic autocorrelation size associated with any pattern you are searching for.
* 20160218 __multi emitter fitting__ needs pertubation on its initial conditions?  if two spots start at the same position in parameter space, won't they flow together?  or take a long time for the numerical error to diverge the solutions?  
* 20160218 __multi emitter fitting__ basically entails a super position of the single emitter (a single gaussian).  DLambda/DTheta_i for n emitters is simply the sum of the n-1 gaussian with the remaining gaussian of interest being in its derivative form then added.  then take the dot product.  
* 20160218 __gradient ascent__ of the log likelihood entails basically the dot product between DLogLike/DLambda and DLambda/DTheta_i: the first vector being the likelihood error vector between data and the model parameterized by the current set of parameters, and the second vector the derivative of the shape function w.r.t. theta_i.  This is just the chain rule, but having dot product geometry in mind helps.
* 20160207 __what to do?__ after likelihood thresholding there will be blobs of candidate spot locations.  how to process this to hand off to iterative MLE?  h-dome can pluck out local maximas (fast, but pixel resolution).  mean-shift can pluck out local maximas (slow, but subpixel).  log can pluck out local maximas, but can be noisy?  (on 20160320 ran experiment between LOG filter and LL ratio and found LOG filter is way more noisier than using LLRatio -fc)
* 20160213 __passing parameters to functions__ can also pass to subfunctions, so you must list the subfunctions that have the parameters cascaded to them so the user gets a heads up.  Programming rule: append the parameters as you go, so you can have master parameter list for inspection and can be return if desired.
* 20160213 __passing parameters to functions__ can also cascade the varargin to sub-functions.  this allows the user to change many parameters at once from a root function, but be mindful of parameter name collisions.  there is no checking of that!!!!  
* 20160125 __passing parameters to functions__ can be done either two ways: 1) pass a structure with fields over-riding the default parameters, or by a named-value pair, func('param1',value1, ...).  
* 20160125 __organization of this git repo__ is by having different modular projects that interact with each other separated by different folders instead of having indivudal git repos for each project.  