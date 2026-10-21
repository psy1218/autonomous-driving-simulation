% clear all
% clc
% close all

I = imread('parkinglot.png');     % 이미지 읽기
grayI = rgb2gray(I);         % grayscale 변환 (이미 흑백이면 생략)
bw = imbinarize(grayI,0.6);      % 자동 임계값 사용하여 binary 변환

figure(1)
% subplot(2,1,1)
% imshow(bw);

resolution = 18*67.6/64.557;
map = binaryOccupancyMap(bw,resolution);

% subplot(2,1,2)
show(map)


%% 2. 시작 위치(Start) 및 목표 위치(Goal) 설정
startPose = [22.5 7 pi/2];            % [x, y, 방향(rad)] — 차량이 주차장 입구에 위치
goalPose  = [30.5 8 pi/2];       % 원하는 빈 주차칸의 위치와 방향

figure;
show(map); hold on;

% 시작 위치 표시 (방향 벡터 포함)
quiver(startPose(1), startPose(2), cos(startPose(3)), sin(startPose(3)), ...
    2, color=[0 0.75 0.23], LineWidth=2, Marker="o", MarkerFaceColor=[0 0.75 0.23], ...
    MarkerSize=5, DisplayName="Start Pose", ShowArrowHead="off");

% 목표 위치 표시
quiver(goalPose(1), goalPose(2), cos(goalPose(3)), sin(goalPose(3)), ...
    2, color=[1 0 0], LineWidth=2, Marker="o", MarkerFaceColor=[1 0 0], ...
    MarkerSize=5, DisplayName="Goal Pose", ShowArrowHead="off");

legend(Location="southeast");
title("Start and Goal Poses in Parking Lot Map");
hold off;

%% 3. Hybrid A*용 상태 검증기(validator) 생성
%  차량은 2D 위치 + 방향(SE2) 상태공간을 사용
validator = validatorOccupancyMap(stateSpaceSE2, map=map);

validator.ValidationDistance = 0.1;  
% 경로 검증 간격 (0.1m마다 충돌 여부 체크)

%% 4. Hybrid A* 경로 계획기 생성
planner = plannerHybridAStar(validator, ...
    MinTurningRadius=3, ...     % 차량이 최소 회전할 수 있는 반경
    MotionPrimitiveLength=4);   % planner가 사용하는 단위 동작 길이

rng("default");                 % 결과 재현 가능하도록 랜덤 고정

%% 5. Hybrid A* 경로 생성
refPath = plan(planner, startPose, goalPose);  
% Hybrid A* 탐색 실시 → 전진·후진 포함한 유효 경로 생성

path = refPath.States;          % [x,y,θ] 경로 상태들

figure;
show(planner, Tree="off");      % 생성된 경로 시각화 (플래너 내장 함수)
legend(Location="southeast");

%% 6. 생성된 경로의 방향 시각화
figure;
plot(rad2deg(refPath.States(:,3)));  % 각 상태의 방향(θ)을 degree로 표시
title("Orientation of Vehicle Along the Path in degrees");

%% --------------------------------------------------------------
% 7. optimizePathOptions 객체 생성 (경로 최적화를 위한 파라미터 설정)
%    이 객체는 차량 운동학 제약 + 장애물 회피 + 부드러움 등을 비용함수로 관리
%% --------------------------------------------------------------
options = optimizePathOptions;  % 기본 설정 불러오기

%% 7-1. Trajectory Parameters (차량 운동 제약)
options.MinTurningRadius = 3;       % 차량이 허용하는 최소 회전반경
options.MaxVelocity      = 5;       % 최대 속도 (m/s)
options.MaxAcceleration  = 1;       % 최대 가속도 (m/s^2)
options.ReferenceDeltaTime = 0.1;   % 최적화 경로 상태 간 시간 간격 설정

% 경로 길이에 따라 적절한 상태 수 결정
separationBetweenStates = 0.2;      
numStates = refPath.pathLength / separationBetweenStates;
options.MaxPathStates = round(numStates);

%% 7-2. Obstacle Parameters (장애물 회피 관련)
options.ObstacleSafetyMargin      = 2;    % 장애물과의 최소 안전거리
options.ObstacleInclusionDistance = 0.75; % 최적화에 포함할 장애물 거리
options.ObstacleCutOffDistance    = 2.5;  % 최적화에 무시할 장애물 거리

%% 7-3. Solver Parameters (최적화 반복횟수)
options.NumIteration       = 4;     % 전체 최적화 반복 수
options.MaxSolverIteration = 15;    % 내부 solver 반복 횟수

%% 7-4. Weight Parameters (비용함수 가중치)
options.WeightTime             = 10;     % 이동 시간 최소화 가중치
options.WeightSmoothness       = 1000;   % 부드러움 강조
options.WeightMinTurningRadius = 10;     % 회전반경 준수 강조
options.WeightVelocity         = 10;     % 속도 제한 준수 강조
options.WeightObstacles        = 50;     % 장애물 회피 중요도

%% --------------------------------------------------------------
% 8. Hybrid A* 경로를 기반으로 최적화 수행
%% --------------------------------------------------------------

[optimizedPath, kineticInfo] = optimizePath(path, map, options);
% 경로 최적화 실행 → 더 부드럽고 안전한 경로 계산

drivingDir = sign(kineticInfo.Velocity);  
% 각 상태에서 전진(+1) / 후진(-1) 여부 확인

% 전진/후진 구간 분리
forwardMotion = optimizedPath(drivingDir==1,:);
reverseMotion = optimizedPath(drivingDir==-1,:);

%% 9. 최적화된 경로 시각화
figure;
show(planner, Tree="off"); hold on;
quiver(forwardMotion(:,1), forwardMotion(:,2), cos(forwardMotion(:,3)), sin(forwardMotion(:,3)), ...
    0.1, Color=[0 0.45 0.74], LineWidth=1, DisplayName="Optimized Forward Path");
quiver(reverseMotion(:,1), reverseMotion(:,2), cos(reverseMotion(:,3)), sin(reverseMotion(:,3)), ...
    0.1, Color=[0.47 0.68 0.19], LineWidth=1, DisplayName="Optimized Reverse Path");

legend(Location="southeast");
title("Planned Path and Optimized Path");
hold off;

%% 10. 최적화된 경로의 방향 변화 시각화
figure;
plot(rad2deg(optimizedPath(:,3)));
title("Orientation of Vehicle Along the Optimized Path in degrees");
