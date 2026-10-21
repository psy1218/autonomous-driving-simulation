close all

Ts = 0.02;
Ld0 = 3;
L = [5 2];
v_ref = [5 -2];
kp = 10;
presentLane = 2;
count = 100;

trajectory = out.simout.Data;


figure(100)
hold on

% plot(x_ref1,y_ref1)
plot(x_ref2,y_ref2)
plot(checkPoint(1),checkPoint(2),'ro')

% plot(trajectory(:,1),trajectory(:,2),'LineWidth',2,'Color',[1 0.5 0.5])


% figure(200)
% plot(trajectory(:,3))