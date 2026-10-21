clear all
clc
close all

load('data.mat')

open('LaneMarkerDetectorTestBench')

%%
v = 5;

%------------------ 경로 정의 & 누적 호길이 ------------------
global x_ref y_ref s

dx = diff(x_ref'); 
dy = diff(y_ref');
s  = [0, cumsum(hypot(dx,dy))];         % 누적 호길이

figure(1); 
plot(x_ref,y_ref,'k--','LineWidth',1.5); 
hold on; axis equal; grid on;

pause(2)
%%------------------ 차량 파라미터 ------------------
global Ld0 L
x0=0; y0=10; yaw0=pi/2;                         % 초기 상태(뒤축 기준)
L=2;                                   % wheelbase
v=10.0;                                   % m/s
Ld0=5;                                 % 기본 look-ahead
dt=0.01;                                 % 더 작은 타임스텝로 안정화

delta = 1;


x0 = x_ref(1);
y0 = y_ref(1);
yaw0 = yaw_ref(1);


%%

sim('LaneMarkerDetectorTestBench')
