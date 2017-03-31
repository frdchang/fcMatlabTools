function [ L ] = splitTheBorders(Lbroken,L )
%SPLITTHEBRODERS will take the broken up masks of Lbroken, and see if there
%are gaps.  the gaps will then be split between the masks so there are no
%gaps.

gap = xor(Lbroken > 0,L);


end

