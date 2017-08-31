function [  ] = clearCluster( )
%CLEARCLUSTER Summary of this function goes here
%   Detailed explanation goes here
try
   c = parcluster;
   c.Jobs.delete; 
catch
    warning('no cluster to clear');
end

end

