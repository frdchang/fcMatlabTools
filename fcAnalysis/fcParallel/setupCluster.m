function [] = setupCluster(varargin)
%SETUPCLUSTER setups the cluster
%--parameters--------------------------------------------------------------
params.setWallTime     = '01:00:00';
params.setQueueName    = 'serial_requeue';
params.setMemUsage     = '8000';
%--------------------------------------------------------------------------
params = updateParams(params,varargin);
try
    clearCluster();
catch
    
end

if exist('ClusterInfo','var')== 0
    try
        configCluster;
    catch
        error('there is no cluster configuration');
    end
else
    
end

try
c = parcluster;
c.AdditionalProperties.MemUsage = params.setMemUsage;
c.AdditionalProperties.WallTime = params.setWallTime;
c.AdditionalProperties.QueueName = params.setQueueName;
% c.AutoAttachFiles = true;
c.saveProfile;
catch
    
end


% ClusterInfo.setWallTime(params.setWallTime);
% ClusterInfo.setQueueName(params.setQueueName);
% ClusterInfo.setMemUsage(params.setMemUsage);

