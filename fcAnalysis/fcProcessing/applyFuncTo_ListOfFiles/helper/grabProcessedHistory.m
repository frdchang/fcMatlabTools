function [ grabHistory ] = grabProcessedHistory( savePath )
%GRABPROCESSEDHISTORY Summary of this function goes here
%   Detailed explanation goes here

grabHistory     = regexp(savePath,'\[(.*?)\]','match');

end

