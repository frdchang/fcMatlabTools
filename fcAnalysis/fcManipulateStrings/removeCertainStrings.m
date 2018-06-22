function [ fileList ] = removeCertainStrings( fileList,keepFile )
%REMOVECERTAINSTRINGS Summary of this function goes here
%   Detailed explanation goes here

    dsCheck = regexp(fileList,keepFile);
    dsCheck = ~cellfun('isempty',dsCheck);
    fileList(dsCheck) = [];  
end

