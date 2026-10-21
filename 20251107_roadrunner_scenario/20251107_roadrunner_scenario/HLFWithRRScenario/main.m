clear all
clc
close all


%%


load('reference.mat')


global x_ref1 y_ref1 yaw_ref1 x_ref2 y_ref2 yaw_ref2 Ld0 L

x_ref1 = refined_reference_inside_x;
y_ref1 = refined_reference_inside_y;
yaw_ref1 = refined_reference_inside_yaw;

x_ref2 = refined_reference_outside_x;
y_ref2 = refined_reference_outside_y;
yaw_ref2 = refined_reference_outside_yaw;

Ld0 = 10;
L = 2.4;

v_ref = 27;
kp = 10;

%%
if ~ispc
    error(['This example is supported only on Microsoft.',char(174),' Windows',char(174),'.'])
end

pathToCurvedRRScene = fullfile(matlabshared.supportpkg.getSupportPackageRoot,"toolbox","shared","sim3dprojects","spkg","roadrunner","RoadRunnerProject","Scenes","CurvedRoad.rrscene");
pathToStrightRRScene = fullfile(matlabshared.supportpkg.getSupportPackageRoot,"toolbox","shared","sim3dprojects","spkg","roadrunner","RoadRunnerProject","Scenes","StraightRoad.rrscene");
pathToAssets = fullfile(matlabshared.supportpkg.getSupportPackageRoot,"toolbox","shared","sim3dprojects","spkg","roadrunner","RoadRunnerProject","Assets","Markings","*.rrmeta");

if (~exist(pathToCurvedRRScene, 'file') && ~exist(pathToStrightRRScene, 'file'))
    error('This example requires you to download and install Automated Driving Toolbox Interface for Unreal Engine 4 Projects support package');
end

rrAppPath = "C:\Program Files\RoadRunner R2024b\bin\win64";
rrProjectPath = "C:\Users\dglee\OneDrive\문서\RoadRunner Project";

s = settings;
s.roadrunner.application.InstallationFolder.TemporaryValue = rrAppPath;

rrApp = roadrunner(rrProjectPath);

openProject("HLFWithRRScenario");



HLFWithRRScenarioProject = currentProject;
projectPath = convertStringsToChars(HLFWithRRScenarioProject.RootFolder);
projectRootFolder = projectPath(1:find(projectPath=='\',1,'last')-1);

copyfile(pathToCurvedRRScene,fullfile(rrProjectPath,"Scenes"),'f')
copyfile(pathToStrightRRScene,fullfile(rrProjectPath,"Scenes"),'f')
copyfile(fullfile(projectRootFolder,"HLFTestScenarios/RoadRunner/Scenarios"),fullfile(rrProjectPath,"Scenarios"),'f')
copyfile(fullfile(projectRootFolder,"HLFWithRRScenario/TestBench/HLF.rrbehavior.rrmeta"),fullfile(rrProjectPath,"Assets","Behaviors"),'f')
copyfile(pathToAssets, fullfile(rrProjectPath,"Assets/Markings"),'f')


%%
openScene(rrApp,"competition.rrscene")
openScenario(rrApp,"competition.rrscenario")

rrSim = createSimulation(rrApp);
set(rrSim,Logging="on");

Ts = 0.01;
set(rrSim,StepSize=Ts)

open_system("HighwayLaneFollowingRRTestBench")

mpcverbosity("off");

helperSLHighwayLaneFollowingWithRRSetup(rrApp,rrSim,scenarioFileName="competition")

set_param("HighwayLaneFollowingRRTestBench",SimulationCommand="update")

