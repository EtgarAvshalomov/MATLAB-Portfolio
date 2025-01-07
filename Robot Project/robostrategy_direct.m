function [move,mem] = robostrategy_direct(env,mem)
%Strategy for robot tournament game, following opponent
%
%Environment Struct
% field:
% info,  STRUCT{team, fuel, myPos, oppPos}
% basic, STRUCT{walls, rRbt, rMF, lmax}
% mines, STRUCT{nMine, mPos, mineScr, mineExist}
% fuels, STRUCT{nFuel, fPos, fuelScr, fuelExist}
%
%Memory Struct
% field:
% path, STRUCT{start, dest, pathpt, nPt, proc, lv}

mypos=env.info.myPos;
lmax=env.basic.lmax;
move= [lmax lmax/2];

end
