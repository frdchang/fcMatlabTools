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
subFunc1(params);
end
```

- complicated functions with sub-functions should be organized by the following folder hierarchy.
  ``` 
./doFunc
./doFunc/helper
./doFunc/testFunctions
./doFunc/doFunc.m
```

## datastructures used in the code:
- spotParamStruct is a container that is used to hold various parameters of a spot.  Depending how it is used, not all parameters are populated.
this container should be able to handle different fits, such as 0 spots, 1 spot, 2 spots etc.
  * for synthetic spot generation it is organized like so:
{spotParamStruct1,spotParamStruct2,...}
  * for parameters of different models extract for many patches of data it is organized like so:
{{spotParamStruct1forPatch1,spotParamStruct2,...},{spotParamStruct1,spotParamStruct2,...}

  a sample spot param data structure may look like the following:
  ```
spotParamStruct.xp          = x position in the specimen plane (m)
spotParamStruct.yp          = y position in the specimen plane (m)
spotParamStruct.zp          = z position in the specimen plane (m)
spotParamStruct.xPixel      = x position in pixel units
spotParamStruct.yPixel      = y position in pixel units
spotParamStruct.zPixel      = z position in slice number units
spotParamStruct.amp1        = value of peak amplitude given 1 spot
spotParamStruct.bak1        = value of the background given 1 spot
spotParamStruct.logLike1    = Likelihood of Fit given 1 spot
spotParamStuct.bak0         = value of the background given background only model (0 spot)
spotParamStruct.logLike0    = likelihood of fit given background only model (0 spot)
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
* 20160224 __gradient ascent__ actually doesn't really need inplace operations since memory allocation is very fast in 2015b.  (so not a big deal), but anonymous functions 
* 20160220 __gradient ascent__ should take advantage of inplace operations since I shouldn't allocate memory for every step.  
* 20160220 __gradient ascent__ should recieve nd-data flattened as column major vectors since the gradient calculation is a dot product anyways.    
* 20160220 __thresholding likelihoood__ can be filtered by the minimal connected volume because there is a characteristic autocorrelation size associated with any pattern you are searching for.
* 20160218 __multi emitter fitting__ needs pertubation on its initial conditions?  if two spots start at the same position in parameter space, won't they flow together?  or take a long time for the numerical error to diverge the solutions?  
* 20160218 __multi emitter fitting__ basically entails a super position of the single emitter (a single gaussian).  DLambda/DTheta_i for n emitters is simply the sum of the n-1 gaussian with the remaining gaussian of interest being in its derivative form then added.  then take the dot product.  
* 20160218 __gradient ascent__ of the log likelihood entails basically the dot product between DLogLike/DLambda and DLambda/DTheta_i: the first vector being the likelihood error vector between data and the model parameterized by the current set of parameters, and the second vector the derivative of the shape function w.r.t. theta_i.  This is just the chain rule, but having dot product geometry in mind helps.
* 20160207 __what to do?__ after likelihood thresholding there will be blobs of candidate spot locations.  how to process this to hand off to iterative MLE?  h-dome can pluck out local maximas (fast, but pixel resolution).  mean-shift can pluck out local maximas (slow, but subpixel).  log can pluck out local maximas, but can be noisy?  
* 20160213 __passing parameters to functions__ can also pass to subfunctions, so you must list the subfunctions that have the parameters cascaded to them so the user gets a heads up.  Programming rule: append the parameters as you go, so you can have master parameter list for inspection and can be return if desired.
* 20160213 __passing parameters to functions__ can also cascade the varargin to sub-functions.  this allows the user to change many parameters at once from a root function, but be mindful of parameter name collisions.  there is no checking of that!!!!  
* 20160125 __passing parameters to functions__ can be done either two ways: 1) pass a structure with fields over-riding the default parameters, or by a named-value pair, func('param1',value1, ...).  
* 20160125 __organization of this git repo__ is by having different modular projects that interact with each other separated by different folders instead of having indivudal git repos for each project.  