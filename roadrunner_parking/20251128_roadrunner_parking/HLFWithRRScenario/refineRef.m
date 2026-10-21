global x_ref1 y_ref1 yaw_ref1 x_ref2 y_ref2 yaw_ref2

x_ref1 = optimizedPath2(1:idx,1)';
y_ref1 = optimizedPath2(1:idx,2)';
yaw_ref1 = optimizedPath2(1:idx,3)';

x_ref2 = optimizedPath2((idx+1):end,1)';
y_ref2 = optimizedPath2((idx+1):end,2)';
yaw_ref2 = optimizedPath2((idx+1):end,3)';



numOfExt = 100;
SL = 0.05;


for i=1:numOfExt
    x_ref1 = [x_ref1 x_ref1(idx)+i*SL*cos(yaw_ref1(idx))];
    y_ref1 = [y_ref1 y_ref1(idx)+i*SL*sin(yaw_ref1(idx))];
    yaw_ref1 = [yaw_ref1 yaw_ref1(idx)];

    x_ref2 = [x_ref2(1+i)+i*SL*cos(yaw_ref1(idx)) x_ref2];
    y_ref2 = [y_ref2(1+i)+i*SL*sin(yaw_ref1(idx)) y_ref2];
    yaw_ref2 = [yaw_ref1(idx) yaw_ref2];
end

for i=1:numOfExt*20
    x_ref2 = [x_ref2 x_ref2(end)+i*SL*cos(yaw_ref2(end)+pi)];
    y_ref2 = [y_ref2 y_ref2(end)+i*SL*sin(yaw_ref2(end)+pi)];
    yaw_ref2 = [yaw_ref2 yaw_ref2(end)];
end

close all
figure(1)
plot(x_ref1,y_ref1,'r')
hold on
plot(x_ref2,y_ref2,'b')
