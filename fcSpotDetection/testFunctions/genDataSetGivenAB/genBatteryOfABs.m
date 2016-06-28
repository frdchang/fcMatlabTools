function [] = genBatteryOfABs(varargin)
%GENBATTERYOFABS will generate a battery of A and B conditions

A = [10,1000];
B = 10;

for AA = A
    for BB = B
        genDataSetGivenAB(AA,BB,varargin{:});
    end
end



