function [ mse ] = logLike_MSE(data,lambda,varargin)
%LOGLIKE_MSE calculates the mse

if iscell(data) && iscell(lambda) 
    mse = cellfun(@(data,lambda) mean((data(:) - lambda(:)).^2),data,lambda);
    mse = -mean(mse);
else
    mse = -mean((data(:) - lambda(:)).^2);
end
