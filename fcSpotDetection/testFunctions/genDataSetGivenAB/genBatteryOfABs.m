function [] = genBatteryOfABs()
%GENBATTERYOFABS will generate a battery of A and B conditions

A = 1:1000;
B = 10;

for AA = A
    for BB = B
        genDataSetGivenAB(AA,BB);
    end
end



