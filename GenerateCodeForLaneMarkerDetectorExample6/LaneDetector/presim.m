clear all
clc
close all

open('presim_LaneMarkerDetectorTestBench')

sim('presim_LaneMarkerDetectorTestBench')

data = simout;

time = data.time;
x_ref = data.data(:,1);
y_ref = data.data(:,2);
yaw_ref = data.data(:,3);


figure(1)
plot(x_ref,y_ref)

save('data.mat')