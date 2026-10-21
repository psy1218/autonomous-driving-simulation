clear all
clc
close all

global x_ref1 y_ref1 yaw_ref1 x_ref2 y_ref2 yaw_ref2 Ld0 L v_ref Ts presentLane count




params;

genMap;

% true_startPose = vehSim3D.InitialPos;
% error_initialPos = -startPose;
optimizedPath2 = optimizedPath-[startPose(1:2)+[4.5,12] 0];;

%%
idx = find( sign(kineticInfo.Velocity(1:end-1)) > 0 & sign(kineticInfo.Velocity(2:end)) < 0 );

idx = idx(2);
idx = idx+1;
x_ref1 = optimizedPath2(1:idx,1)';
y_ref1 = optimizedPath2(1:idx,2)';
yaw_ref1 = optimizedPath2(1:idx,3)';


x_ref2 = optimizedPath2( (idx+1):end,1)';
y_ref2 = optimizedPath2( (idx+1):end,2)';
yaw_ref2 = optimizedPath2( (idx+1):end,3)';

refineRef;
global checkPoint
checkPoint = [x_ref1(idx+numOfExt/2); y_ref1(idx+numOfExt/2)];
open_system('sim2');
yaw0 = pi/2;
