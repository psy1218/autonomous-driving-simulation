close all

figure(10)
plot(x_ref1,y_ref1)
hold on
plot(x_ref2,y_ref2)
plot(checkPoint(1),checkPoint(2),'ro')

plot(true_startPose(1),true_startPose(2),'bo')

plot(posOfEgoVehicle.Data(:,1),posOfEgoVehicle.Data(:,2),'black','linewidth',1.5)

axis([-15 -5 -25 0]);