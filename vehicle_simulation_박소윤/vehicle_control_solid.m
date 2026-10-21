clc; 
clear; 
close all;

%------------------ 경로 정의 & 누적 호길이 ------------------
global x_ref y_ref s 
t = linspace(0,100,400);                 % 더 촘촘한 경로
x_ref = t;
y_ref = 3*sin(t/10);
dx = diff(x_ref); 
dy = diff(y_ref);
s  = [0, cumsum(hypot(dx,dy))];         % 누적 호길이
figure(1); 
plot(x_ref,y_ref,'k--','LineWidth',1.5); 
hold on; axis equal; grid on;

pause(2)
%------------------ 차량 파라미터 ------------------
global Ld0 L
x0=0; y0=10; yaw0=pi/2;                         % 초기 상태(뒤축 기준)
L=2;                                   % wheelbase
v = 10.0;
%v=5.0;                                   % m/s
Ld0=5;                                 % 기본 look-ahead
dt=0.01;                                 % 더 작은 타임스텝로 안정화
traj = nan(2000,2);                      % 궤적 저장

delta = 1;

k = 180/pi;

%%
simTime = 15;
sim('unreal_engine_test');

data = ans ; 

time = data.simout.time;
X = data.simout.signals.values(:,1);
Y = data.simout.signals.values(:,2);
Yaw = data.simout.signals.values(:,3);

plot(X,Y,'red')

%figure(10)
%subplot(3,1,1)
%plot(time, X)
%xlabel('time')
%ylabel('X')

%subplot(3,1,2)
%plot(time, Y)
%xlabel('time')
%ylabel('Y')

%subplot(3,1,3)
%plot(time, Yaw)
%xlabel('time')
%ylabel('Yaw')

%figure(11)
%plot(X,Y)