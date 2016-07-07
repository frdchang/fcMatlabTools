function [] = genBatteryOfABs(varargin)
%GENBATTERYOFABS will generate a battery of A and B conditions

A = [1 2 3 4 5 6 7 8 9 10 100];
B = 10;

for AA = A
    for BB = B
        genDataSetGivenAB(AA,BB,varargin{:});
    end
end



