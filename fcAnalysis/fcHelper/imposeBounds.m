function myCoor = imposeBounds(myCoor,boundMin,boundMax)
%IMPOSEBOUNDS will make sure myCoor is bounded.  

violateMins = myCoor < boundMin;
violateMaxs = myCoor > boundMax;

myCoor(violateMins) = boundMin;
myCoor(violateMaxs) = boundMax;



end

