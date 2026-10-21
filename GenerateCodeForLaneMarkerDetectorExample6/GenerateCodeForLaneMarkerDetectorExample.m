%% Generate Code for Lane Marker Detector 
% This example shows how to test a monocular-camera-based lane marker
% detector and generate C++ code for real-time applications on a prebuilt
% 3D scene from the Unreal Engine&reg; driving simulation environment. This
% example validates the lane marker detector algorithm using metrics and
% verifies the generated C++ code by using software-in-the-loop simulation.

% Copyright 2020-2022 The MathWorks, Inc.

%% Introduction
% A lane marker detector is a fundamental perception component of an
% automated driving application. The detector analyzes images of roads
% captured using a monocular camera sensor and returns information about
% the curvature and marking type of each lane. You can design and simulate
% a lane marker detector algorithm using MATLAB(R) or Simulink(R) and
% assess its accuracy using a known ground truth. You can do C++ code
% generation to integrate the detector to an external software environment
% and deploy to a vehicle. Performing code generation and verification of
% the Simulink model ensures functional equivalence between simulation and
% real-time implementation.
%
% For information about how to design a lane marker detector, see the
% <docid:driving_ug#mw_648333df-e9c3-4106-abea-4098feefa047 Design Lane
% Marker Detector Using Unreal Engine Simulation Environment> example. This
% example shows how to test the lane marker detector in a 3D simulation
% environment and generate C++ code for real-time implementation. In this
% example, you will:
%
% # Explore and simulate the lane marker detector model. 
% # Assess accuracy of the lane marker detector algorithm by comparing with
% the ground truth.
% # Generate C++ code from the algorithm model.
% # Verify implementation with software-in-the-loop (SIL) simulation.
% # Assess execution time and perform code coverage analysis. To perform
% code coverage analysis, you must use Simulink Coverage&trade;.
%
% This example tests the lane marker detector algorithm on a 3D
% simulation environment that uses Unreal Engine&reg; from
% Epic Games&reg;.
%%
if ~ispc
    error(['This example is supported only on Microsoft.', char(174), ' Windows', char(174), '.']);
end
%%
% To explore the test bench model, load the lane detector project.
openProject("LaneDetector");
%%
% To ensure reproducibility of the simulation results, set the random seed.
rng(0);
%% Explore the Model
% The lane marker detector system in this example has a lane marker
% detector test bench and reference model.
%
% * Test Bench Model: The test bench model simulates and tests the
% behavior of the lane marker detector algorithm in an open-loop.
% * Reference Model: The *Lane Marker Detector* block in the test bench
% model invokes the |LaneMarkerDetector| reference model. The reference
% model implements the lane marker detection algorithm and generates the
% C++ code of the algorithm. This reference model can be integrated with
% closed-loop systems.
%
% Open the test bench model.
%%
open_system('LaneMarkerDetectorTestBench');
%%
% Opening this model runs the |helperSLLaneMarkerDetectorSetup| script that
% initializes the road scenario using the <docid:driving_ref#bvm8jbf
% drivingScenario> object in the base workspace. It also configures the
% lane marker detector parameters, vehicle model parameters, and the
% Simulink bus signals required for defining the inputs and outputs
% for the |LaneMarkerDetectorTestBench| model. The test bench model
% contains these subsystems:
%
% # Simulation 3D Scenario: Specifies the scene, vehicles, and camera
% sensor used for simulation.
% # Lane Marker Detector: Implements the lane marker detector algorithm.
% # Metrics Assessment: Assesses the lane marker detector algorithm
% behavior using metrics that include true positives, false positives, and
% false negatives.
% # Visualization: Displays the frame captured by the camera sensor and
% overlays the lane detections during the simulation.
% 
% The *Simulation 3D Scenario* subsystem configures the road network, sets
% vehicle positions, and synthesizes sensors. This is similar to the
% Simulation 3D Scenario subsystem in the
% <docid:driving_ug#mw_574c4bc8-4369-4da6-a4d3-aa48e7e31f92 Highway Lane
% Following> example. However, the Simulation 3D Scenario subsystem used in
% this example does not have a radar sensor. It uses the
% <docid:driving_ref#mw_e07bfe36-17d0-4326-b961-8c7c2aa0fc71 Simulation 3D
% Vision Detection Generator> block to get the ground truth lane boundaries
% for metrics computation. Open the *Simulation 3D Scenario* subsystem.
%%
open_system('LaneMarkerDetectorTestBench/Simulation 3D Scenario');
%%
% *Lane Marker Detector* is the reference model that detects the lane
% boundaries in the frames. Open the *Lane Marker Detector* reference
% model.
%%
open_system('LaneMarkerDetector');
%%
% The *Lane Marker Detector* block uses a System object&trade;,
% |HelperLaneDetectorWrapper|, that configures and implements the lane
% marker detection algorithm. The block takes the frames captured by a
% camera sensor as input and outputs the detected lane boundaries by using
% the |LaneSensor| Simulink bus.
%%
% The *Metrics Assessment* subsystem evaluates the accuracy of detection
% results using the ground truth information. Open the *Metrics Assessment*
% subsystem.
%%
open_system('LaneMarkerDetectorTestBench/Metrics Assessment');
%%
% The *Metrics Assessment* subsystem compares the detected lane boundaries
% and the ground truth lane boundaries by using the
% <docid:driving_ref#bvlj1ll-1 evaluateLaneBoundaries> function. The
% function computes the lateral distance between the detected lane
% boundaries and the ground truth data. If the computed distance is within
% a particular threshold, then the detected boundary is considered as a
% valid match (true positive) and the corresponding lane status is set to
% 1. Otherwise, the function evaluates whether the boundary is a false
% negative or false positive and then sets the lane status to 0. The
% subsystem connects the outputs |left_lane_status| and |right_lane_status|
% to the lamps in the dashboard. The lamps go |green| when the lane status
% is 1 and go |red| when the lane status is 0. The outputs
% |left_lane_metrics| and |right_lane_metrics| are 1-by-3 arrays containing
% the lane matches (true positives), misses (false negatives) and false
% positives for left and right lanes respectively. The average left lane
% and right lane deviations computed from the detected lane boundaries are
% returned at the outputs |left_lane_distance| and |right_lane_distance|
% respectively. The model uses these deviation values to verify the
% accuracy of the algorithm during the simulation using
% <docid:simulink_ref#f6-1667783 Check Static Range> blocks: *Verify Left
% Lane Deviation* and *Verify Right Lane Deviation*.
%
%% Simulate the Model
% Configure the |LaneMarkerDetectorTestBench| model to simulate in the
% |scenario_LD_02_Curve_SixVehicles| scenario. This scenario contains six
% vehicles, including the ego vehicle, and defines their trajectories.
%% 
helperSLLaneMarkerDetectorSetup("scenario_LD_02_Curve_SixVehicles");
%%
% Simulate the test bench model. Use the visualization window and the
% status lamps on the dashboard to view the detection results while the
% simulation is running.
%%
sim('LaneMarkerDetectorTestBench');
%%
% <<../LMD_SimulationOutput.png>>
%%
% You can also visualize the ground truth
% lane boundaries by enabling the |EnableTruthDisplay| mask parameter in
% the *Visualization* block.
%% Assess Accuracy of Algorithm
% Analyze the detection results and validate the overall
% performance of the algorithm.
% 
% During simulation, the model outputs three parameters that characterize a
% lane boundary: curvature, heading angle, and lateral offset. The model
% logs these parameters for the detected lane boundaries and ground truth
% to the base workspace variable |logsout|. You can plot the values in
% |logsout| by using the |helperLaneBoundaryParams| function.
helperPlotLaneBoundaryParams(logsout);
%%
% From the plots, you can infer the deviations between the ground truth and
% the detected lane boundaries. A large deviation between the plots
% indicates that the detected lane boundary is significantly away from the
% ground truth.
%
% You can also verify the performance of the lane marker detector algorithm
% by validating and plotting the metrics separately for the left lane and
% the right lane. The model also logs the detection results for the left 
% and right lanes computed by the *Metrics Assessment* subsystem to the base
% workspace variable |logsout|. The *Metrics Assessment* subsystem outputs:
% 
% # *Left lane metrics*: Returned as an array that contains the number of
%  matches (true positives), misses (false negatives), and false
% positives computed from detections for the left lane of the road.
% # *Left lane status*: Returned as true or false. The value is true for
% matches in the left lane and false for misses and false positives in the
% left lane.
% # *Left lane distance*: A scalar specifying the average value of
% distances between detected left lane boundary points and the ground truth
% for the left lane.
% # *Right lane metrics*: Returned as an array that contains the number of
% matches (true positives), misses (false negatives), and false
% positives computed from detections for the right lane of the road.
% # *Right lane status*: Returned as true or false. The value is true for
% matches in the right lane and false for misses and false positives in the
% right lane.
% # *Right lane distance*: A scalar specifying the average value of
% distances between detected right lane boundary points and the ground
% truth for the right lane.
%
% Plot the detection results for left and right lanes by using the
% |helperPlotLaneMetrics| script:
%%
[numLaneMatches, numLaneMisses, numFalsePositives] = helperPlotLaneMetrics(logsout);
%%
% From the plots you can infer that all the detected left lane and the
% right lane boundaries match with the ground truth and that there are no false
% positives or false negatives.
%
% During simulation, the model records the output of the camera sensor to
% |forwardFacingCamera.mp4|. You can overlay the deviation results on the
% lanes detected in the frames and record to a video file by using
% |helperPlotLaneDetectionResults| function.
% 
%%
hVideoViewer = helperPlotLaneDetectionResults(...
logsout, "forwardFacingCamera.mp4" , scenario, camera,scenarioFcnName,...
"RecordVideo", true,"RecordVideoFileName", scenarioFcnName,...
"OpenRecordedVideoInVideoViewer", true,"VideoViewerJumpToTime", 9.3);
%% 
% You can also compute overall precision and sensitivity of the lane marker
% detection algorithm as below:
%  
% *Precision*: Compute as the percentage of true positives in the total
% number of detected lane boundaries.
%%
precision = (numLaneMatches./(numLaneMatches+numFalsePositives))*100;
disp(precision);
%%
% *Sensitivity*: Compute as the percentage of true positives in total
% number of actual lane boundaries.
%%
sensitivity = (numLaneMatches./(numLaneMatches+numLaneMisses))*100;
disp(sensitivity);
%% 
% The precision and the sensitivity values of a robust lane marker detector
% must be close to 100 for different test scenarios and test conditions.
%
%% Generate C++ Code
% You can now generate C++ code for the algorithm, apply common
% optimizations, and generate a report to facilitate exploring the
% generated code.
%
% Configure the |LaneMarkerDetector| model to generate C++ code
% for real-time implementation of the algorithm. Set the model parameters
% to enable code generation and display the configuration values.
% 
% Set and view model parameters to enable C++ code generation.
%%
helperSetModelParametersForCodeGeneration('LaneMarkerDetector');
save_system('LaneMarkerDetector');
%% 
% Generate code and review the code generation report from the reference
% model.
%%
slbuild('LaneMarkerDetector');
%% 
% Use the code generation report to explore the generated code. To
% learn more about the code generation report, see <docid:ecoder_ug#btcfnxv
% Reports for Code Generation>. Use the Code Interface Report link in the
% Code Generation Report to explore these generated methods:
%
% * |LaneMarkerDetector_initialize|: Call once on initialization.
% * |LaneMarkerDetector_step|: Call periodically every step to execute the
% lane marker detection algorithm.
% * |LaneMarkerDetector_terminate|: Call once on termination.
%
% Additional get and set methods for signal interface are declared in
% |LaneMarkerDetector.h| and defined in |LaneMarkerDetector.cpp|.
%
%% Assess Functionality of Code
% After generating C++ code for the lane marker detector, you can now assess
% the code functionality using software-in-the-loop (SIL) simulation. It
% provides early insight into the behavior of a deployed application. To
% learn more about SIL simulation, refer to <docid:ecoder_ug#br90rb7 SIL
% and PIL Simulations>.
% 
% SIL simulation enables you to verify that the compiled generated code on
% the host is functionally equivalent to the normal mode.
%
% Configure algorithm and test bench model parameters to support SIL
% simulation and log execution profiling information.
%%
helperSetModelParametersForSIL('LaneMarkerDetector');
helperSetModelParametersForSIL('LaneMarkerDetectorTestBench');
%%
% Configure the test bench model to simulate *Lane Marker Detector* in
% software-in-the-loop (SIL) mode.
%%
set_param('LaneMarkerDetectorTestBench/Lane Marker Detector','SimulationMode','Software-in-the-loop (SIL)');
sim('LaneMarkerDetectorTestBench');
%%
% You can compare the outputs from normal simulation mode and
% software-in-the-loop (SIL) simulation mode. You can verify if the
% differences between these runs are in the tolerance limits by using the
% following code. Plot the differences of the detected lane boundary
% parameters between the normal simulation mode and SIL simulation mode.
%%
runIDs = Simulink.sdi.getAllRunIDs;
normalSimRunID = runIDs(end - 1);
SilSimRunID = runIDs(end);
diffResult = Simulink.sdi.compareRuns(normalSimRunID ,SilSimRunID);
%% 
% Plot the differences between lane boundary parameters computed from
% normal mode and SIL mode.
%%
helperPlotDiffSignals(diffResult);
%% 
% Notice that the differences between the lane boundary parameter
% values between normal mode of simulation and SIL mode of simulation are
% approximately zero. However, there are slight differences because of
% different rounding off techniques used by different compilers.
%% Assess Execution Time and Coverage of Code
% During the software-in-the-loop (SIL) simulation, log the execution time
% metrics for the generated code on the host computer to the variable
% |executionProfile| in the MATLAB base workspace. These times can be an
% early indicator for performance of the generated code. For accurate
% execution time measurements, profile the generated code when it is
% integrated into the external environment or when using with
% processor-in-the-loop (PIL) simulation. To learn more about SIL
% profiling, refer to <docid:ecoder_ug#bst4d8a Code Execution Profiling
% with SIL and PIL>.
% 
% Plot the execution time taken for |LaneMarkerDetector_step| function
% using |helperPlotExecutionProfile| function.
%%
helperPlotExecutionProfile(executionProfile);
%%
% Notice that you can deduce the average time taken per frame for the lane
% marker detector from this plot. For more information on generating
% execution profiles and analyzing them during SIL simulation, refer to 
% <docid:ecoder_ug#bufar0v-1 Execution Time Profiling for SIL and PIL>.
%
% If you have a Simulink Coverage&trade; license, you can also perform the
% code coverage analysis for the generated code to measure the testing
% completeness. You can use missing coverage data to find gaps in testing,
% missing requirements, or unintended functionality. Configure the coverage
% settings and simulate the test bench model to generate coverage analysis
% report. Find the generated report
% |CoverageResults/LaneMarkerDetector.html| in the working directory.
%%
if(license('test','Simulink_Coverage'))
    helperCoverageSettings('LaneMarkerDetectorTestBench');
    cvDataObj = cvsim('LaneMarkerDetectorTestBench');
    cvhtml('CoverageResults/LaneMarkerDetector',cvDataObj);
end
%%
% <<../LMD_CoverageForLaneMarkerDetector.png>>
%%  
% You can find the decision coverage, statements coverage and function
% coverage results while simulating the generated code for this test
% scenario, |scenario_LD_02_Curve_SixVehicles|. You can test this model with
% different scenarios to get full coverage of the generated code. For more
% information on how to analyze coverage results during
% software-in-the-loop simulation, refer <docid:ecoder_ug#bu7wg02-1 Code
% Coverage for Models in Software-in-the-Loop (SIL) Mode and
% Processor-in-the-Loop (PIL) Mode>
%
%% Explore Additional Scenarios
% This example provides additional
% scenarios that you can use with the |LaneMarkerDetectorTestBench|
% model:
%
%    scenario_LF_01_Straight_RightLane
%    scenario_LF_02_Straight_LeftLane
%    scenario_LF_03_Curve_LeftLane 
%    scenario_LF_04_Curve_RightLane
%    scenario_LD_01_Curve_ThreeVehicles
%    scenario_LD_02_Curve_SixVehicles [Default]
%%
%
% * Use scenarios with the prefix |scenario_LF| in the filename to test the
% lane marker detection algorithm without obstruction by other vehicles.
% The vehicles still exist in the scenario but are positioned such that
% they are not within the visible range of the ego vehicle.
% * Use scenarios with the prefix |scenario_LD| in the filename to test the
% lane marker detection algorithm while other vehicles on the road are
% within the visible range of the ego vehicle.
%
% While designing and testing the lane marker detection algorithm in open
% loop, it is helpful to begin with a scenario that has only the ego
% vehicle. To configure the model and workspace for such a scenario, use
% the following code.
%%
helperSLLaneMarkerDetectorSetup("scenario_LF_04_Curve_RightLane");
%%
% You can use this model to integrate RoadRunner&trade; scenes into driving
% scenarios for simulation and testing.