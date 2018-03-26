function [ myPercent ] = percentGPUmem()
%PERCENTGPUMEM Summary of this function goes here
%   Detailed explanation goes here

myGPU = gpuDevice;

myPercent = myGPU.AvailableMemory / myGPU.TotalMemory;


end

