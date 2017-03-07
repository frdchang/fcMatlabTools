function [updateX,updateY,updateZ] = calcNewtonUpdate(gradients,hessians)
%CALCNEWTONUPDATE should be gpu friendly

 [updateX,updateY,updateZ] = arrayfun(@doMatrixInverse,gradients{:},hessians{:});
end

function [myx,myy,myz] = doMatrixInverse(gx,gy,gz,h1,h2,h3,h4,h5,h6,h7,h8,h9)
g = [gx ;gy ;gz];
h = [h1 h4 h7 ; h2 h5 h8; h3 h6 h9];
o = h\g;
myx = o(1);
myy = o(2);
myz = o(3);
end