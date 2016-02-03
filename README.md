fcTools by frederick chang - fchang@fas.harvard.edu - frdchang@gmail.com
===========================================================================

####fctools is a set of matlab tools that i use for my research:
- 3d spot detection
- segmentation
- nD experiment processing
- microscope control

###rules of the code
1.
```
function output = funcName(varargin)
%FUNCNAME does this
% more description
%   *param cascade  -> subFunc1
%                   -> subFunc2
%--parameters--------------------------------------------------------------
params.default1     = 1;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

subFunc1Params.addStuff = 1;
subFunc1(updateParams(params,subFunc1Params)); 
%or
subFunc1(updateParams(params,'param1',1));
%or 
params.addParams1 = 1;
subFunc1(params);
end
```

### datastructures used in the code
1.
spotParamStruct is a container that is used to hold various parameters of a spot.  Depending how it is used, not all parameters are populated.
this container should be able to handle different fits, such as 0 spots, 1 spot, 2 spots etc.

needs:
for a given patch of dataset, multiple models can be fit, thus you need to contain multiple fits
for a given fit, you need to contain all the related parameters
each fit has different parameters
```
spotParamStruct.xp = x position in the specimen plane (m)
spotParamStruct.yp = y position in the specimen plane (m)
spotParamStruct.zp = z position in the specimen plane (m)
spotParamStruct.xPixel = x position in pixel units
spotParamStruct.yPixel = y position in pixel units
spotParamStruct.zPixel = z position in slice number units
spotParamStruct.amp1    = value of peak amplitude given 1 spot
spotParamStruct.bak1    = value of the background given 1 spot
spotParamStruct.logLike1 = Likelihood of Fit given 1 spot
spotParamStuct.bak0 = value of the background given background only model (0 spot)
spotParamStruct.logLike0 = likelihood of fit given background only model (0 spot)
```

##diary of progress:
20160213 - (passing parameters to functions) Also the function to list the subfunctions that have the parameters cascaded to them so the user gets a heads up.  Programming rule: append the parameters as you go, so you can have master parameter list for inspection and can be return if desired.
20160213 - (passing parameters to functions) can also cascade the varargin to sub-functions.  this allows the user to change many parameters at once from a root function, but be mindful of parameter name collisions.  there is no checking of that!!!!  
20160125 - (passing parameters to functions) can be done either two ways: 1) pass a structure with fields over-riding the default parameters, or by a named-value pair, func('param1',value1, ...).  
20160125 - (organization of this git repo) is by having different modular projects that interact with each other separated by different folders instead of having indivudal git repos for each project.  