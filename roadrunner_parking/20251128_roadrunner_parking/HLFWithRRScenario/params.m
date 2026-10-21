
%% General model parameters
assignin('base','Ts',0.02);                   % Algorithm sample time  (s)
assignin('base','v_set', egoVehDyn.VLong0);  % Set velocity (m/s)
assignin('base','TimeDataType', 'double');

%% Path following controller parameters
assignin('base','tau',             0.5);     % Time constant for longitudinal dynamics 1/s/(tau*s+1)
assignin('base','time_gap',        1.5);     % Time gap               (s)
assignin('base','default_spacing', 10);      % Default spacing        (m)
assignin('base','max_ac',          1000);       % Maximum acceleration   (m/s^2)
assignin('base','min_ac',          -1500);      % Minimum acceleration   (m/s^2)
assignin('base','max_steer',       0.26);    % Maximum steering       (rad)
assignin('base','min_steer',       -0.26);   % Minimum steering       (rad)
assignin('base','PredictionHorizon', 30);    % Prediction horizon
assignin('base','ControlHorizon', 2);
assignin('base','v0_ego', egoVehDyn.VLong0); % Initial longitudinal velocity (m/s)
assignin('base','tau2', 0.07);    % Longitudinal time constant (brake)             (N/A)
assignin('base','max_dc', -1000);        % Maximum deceleration   (m/s^2)
assignin('base','LaneWidth', single(3.85)); % Width of the lane (m)


%% Watchdog Braking controller parameters
assignin('base', 'PB1_decel',       3.8);      %1st stage Partial Braking deceleration (m/s^2)
assignin('base', 'PB2_decel',       5.3);      % 2nd stage Partial Braking deceleration (m/s^2)
assignin('base', 'FB_decel',        9.8);      % Full Braking deceleration              (m/s^2)
assignin('base', 'headwayOffset',   3.7);      % headway offset                         (m)
assignin('base', 'timeMargin',      0);
assignin('base', 'timeToReact',     1.2);      % driver reaction time                   (sec)
assignin('base', 'driver_decel',    4.0);      % driver braking deceleration            (m/s^2)
assignin('base','Default_decel', 0);           % Default deceleration (m/s^2)
assignin('base','TimeFactor', 1.2);            % Time factor (sec)
assignin('base','stopVelThreshold', 0.1);      % Velocity threshold for stopping ego vehicle (m/s)

%% Dynamics modeling parameters
assignin('base','m',  1575);                    % Total mass of vehicle                          (kg)
assignin('base','Iz', 2875);                    % Yaw moment of inertia of vehicle               (m*N*s^2)
assignin('base','Cf', 19000000);                   % Cornering stiffness of front tires             (N/rad)
assignin('base','Cr', 33000000);                   % Cornering stiffness of rear tires              (N/rad)
assignin('base','lf', egoVehDyn.CGToFrontAxle); % Longitudinal distance from c.g. to front tires (m)
assignin('base','lr', egoVehDyn.CGToRearAxle);  % Longitudinal distance from c.g. to rear tires  (m)
