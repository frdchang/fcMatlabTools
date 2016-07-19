function [] = genBatteryOfABs(varargin)
%GENBATTERYOFABS will generate a battery of A and B conditions

A = [0 1 2 3 4 5 6 7 8 9 10 100];
B = [0 10 100];

for AA = A
        genDataSetGivenAB(AA,B,varargin{:});
end



