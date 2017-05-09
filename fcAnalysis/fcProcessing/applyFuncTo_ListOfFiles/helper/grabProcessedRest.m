function [ grabRest ] = grabProcessedRest( savePath )
%GRABPROCESSEDREST Summary of this function goes here
%   Detailed explanation goes here

grabRest        = regexp(savePath,'\[(.*?)\]','split');
end

