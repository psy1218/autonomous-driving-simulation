close all

figure(10)
plot(refined_reference_inside_x,refined_reference_inside_y)


trajectoryOfEgoVehicle  = posOfEgoVehicle.Data;

hold on

plot(trajectoryOfEgoVehicle(:,1),trajectoryOfEgoVehicle(:,2))