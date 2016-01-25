fcTools by frederick chang - fchang@fas.harvard.edu - frdchang@gmail.com
===========================================================================

####fctools is a set of matlab tools that i use for my research:
- 3d spot detection
- segmentation
- nD experiment processing
- microscope control

##diary of progress:
20160125 - (passing parameters to functions) is done by passing structures with the parameters defined within them.  the default settings are named 'defaultParams' are defined at the top of the function.  over-riding the default parameters consist of passing a structure 'userParams' in which the function will copy over by setstructfields().

20160125 - (organization of this git repo) is by having different modular projects that interact with each other separated by different folders instead of having indivudal git repos for each project.  