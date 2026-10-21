clear all
clc
close all

load('data.mat')

reference_inside = posOfExtraVehicle2.Data;
reference_outside = posOfExtraVehicle4.Data;

reference_inside_x = reference_inside(:,1);
reference_inside_y = reference_inside(:,2);
reference_inside_yaw = reference_inside(:,3);

reference_outside_x = reference_outside(:,1);
reference_outside_y = reference_outside(:,2);
reference_outside_yaw = reference_outside(:,3);

interval = 1:1:length(reference_inside_x);
interval2 = 1:0.1:length(reference_inside_x);
refined_reference_inside_x = interp1(interval,reference_inside_x,interval2);
refined_reference_inside_y = interp1(interval,reference_inside_y,interval2);
refined_reference_inside_yaw = interp1(interval,reference_inside_yaw,interval2);


refined_reference_inside_x = refined_reference_inside_x(1:2793);
refined_reference_inside_y = refined_reference_inside_y(1:2793);
refined_reference_inside_yaw = refined_reference_inside_yaw(1:2793);

% figure(1)
% plot(1:length(refined_reference_inside_x),refined_reference_inside_x)
% 
% 
% 


interval = 1:1:length(reference_outside_x);
interval2 = 1:0.1:length(reference_outside_x);
refined_reference_outside_x = interp1(interval,reference_outside_x,interval2);
refined_reference_outside_y = interp1(interval,reference_outside_y,interval2);
refined_reference_outside_yaw = interp1(interval,reference_outside_yaw,interval2);


refined_reference_outside_x = refined_reference_outside_x(1:2882);
refined_reference_outside_y = refined_reference_outside_y(1:2882);
refined_reference_outside_yaw = refined_reference_outside_yaw(1:2882);


save('reference.mat','refined_reference_inside_x','refined_reference_inside_y',...
    'refined_reference_inside_yaw', 'refined_reference_outside_x','refined_reference_outside_y',...
    'refined_reference_outside_yaw')