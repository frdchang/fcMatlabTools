fcTools by frederick chang - fchang@fas.harvard.edu - frdchang@gmail.com
===========================================================================

####fctools is a set of matlab tools that i use for my research:
- 3d spot detection
- segmentation
- nD experiment processing
- microscope control

###rules of the code
1)
function output = funcName(varargin)
% comment
%--parameters--------------------------------------------------------------
params.default1     = 1;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);
end

##diary of progress:
20160125 - (passing parameters to functions) can be done either two ways: 1) pass a structure with fields over-riding the default parameters, or by a named-value pair, func('param1',value1, ...).  

20160125 - (organization of this git repo) is by having different modular projects that interact with each other separated by different folders instead of having indivudal git repos for each project.  