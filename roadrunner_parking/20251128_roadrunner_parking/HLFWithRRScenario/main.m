%% 초기 설정
clear all; clc; close all;

if ~ispc
    error(['This example is supported only on Microsoft', char(174), ' Windows', char(174), '.']);
end

%% RoadRunner 기본 경로 설정
spkgRoot = matlabshared.supportpkg.getSupportPackageRoot;
basePath = fullfile(spkgRoot, "toolbox", "shared", "sim3dprojects", "spkg", "roadrunner", "RoadRunnerProject");

pathToCurvedRRScene  = fullfile(basePath, "Scenes", "CurvedRoad.rrscene");
pathToStraightRRScene = fullfile(basePath, "Scenes", "StraightRoad.rrscene");
pathToAssets         = fullfile(basePath, "Assets", "Markings", "*.rrmeta");

if (~exist(pathToCurvedRRScene, 'file') && ~exist(pathToStraightRRScene, 'file'))
    error('Automated Driving Toolbox Interface for Unreal Engine 4 Projects support package가 필요합니다.');
end

%% RoadRunner 실행 및 프로젝트 로드
rrAppPath     = "C:\Program Files\RoadRunner R2025a\bin\win64";
rrProjectPath = "C:\Users\Lee\Documents\New RoadRunner Project";

s = settings;
s.roadrunner.application.InstallationFolder.TemporaryValue = rrAppPath;

rrApp = roadrunner(rrProjectPath);

openProject("HLFWithRRScenario");

%% 테스트 프로젝트 경로
HLFProject    = currentProject;
projectPath   = convertStringsToChars(HLFProject.RootFolder);
projectRoot   = projectPath(1 : find(projectPath=='\',1,'last')-1);

%% RoadRunner 프로젝트 파일 복사
copyfile(pathToCurvedRRScene,        fullfile(rrProjectPath, "Scenes"), 'f');
copyfile(pathToStraightRRScene,      fullfile(rrProjectPath, "Scenes"), 'f');
copyfile(fullfile(projectRoot, "HLFTestScenarios/RoadRunner/Scenarios"), ...
         fullfile(rrProjectPath, "Scenarios"), 'f');
copyfile(fullfile(projectRoot, "HLFWithRRScenario/TestBench/HLF.rrbehavior.rrmeta"), ...
         fullfile(rrProjectPath, "Assets", "Behaviors"), 'f');
copyfile(pathToAssets, fullfile(rrProjectPath, "Assets/Markings"), 'f');

%% RoadRunner Scene/Scenario 로드
openScene(rrApp, "parkingGarage.rrscene");
openScenario(rrApp, "parkingGarage.rrscenario");

%% 시뮬레이션 설정
rrSim = createSimulation(rrApp);
set(rrSim, Logging = "on");

global Ts
Ts = 0.02;
set(rrSim, StepSize = Ts);

%% 제어 파라미터
global Ld L v_ref
Ld    = [3 6];
L     = [5 5];
v_ref = [5 -0.8];
kp    = 10;

%% Simulink 모델 로드
open_system("HighwayLaneFollowingRRTestBench");
mpcverbosity("off");

%% 글로벌 변수 설정
global presentLane
presentLane = 1;

helperSLHighwayLaneFollowingWithRRSetup(rrApp, rrSim, scenarioFileName = "parkingGarage");
set_param("HighwayLaneFollowingRRTestBench", SimulationCommand = "update");

%% 경로 생성 및 오프셋 보정
genMap;

true_startPose = vehSim3D.InitialPos;
error_initialPos = [true_startPose(1:2) - startPose(1:2), 0];
optimizedPath2 = optimizedPath + error_initialPos;

%% 속도 0-crossing 구간 분리
idx = find(sign(kineticInfo.Velocity(1:end-1)) > 0 & ...
           sign(kineticInfo.Velocity(2:end)) < 0);
idx = idx(2);

%% 경로 분할
global x_ref1 y_ref1 yaw_ref1
global x_ref2 y_ref2 yaw_ref2

x_ref1   = optimizedPath2(1:idx, 1)';
y_ref1   = optimizedPath2(1:idx, 2)';
yaw_ref1 = optimizedPath2(1:idx, 3)';

x_ref2   = optimizedPath2(idx+1:end, 1)';
y_ref2   = optimizedPath2(idx+1:end, 2)';
yaw_ref2 = optimizedPath2(idx+1:end, 3)';

%% Reference 경로 보정
refineRef;

%% 체크포인트 설정
global checkPoint
checkPoint = [x_ref1(idx + numOfExt/2); 
              y_ref1(idx + numOfExt/2)];




