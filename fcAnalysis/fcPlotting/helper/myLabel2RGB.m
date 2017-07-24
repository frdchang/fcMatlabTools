function [ labeled ] = myLabel2RGB( L )
%MYLABEL2RGB Summary of this function goes here
%   Detailed explanation goes here

labeled = label2rgb(L,'lines','k','shuffle');
end

