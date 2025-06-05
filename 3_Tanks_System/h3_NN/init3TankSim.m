clc;
close all;
clear all;

%% Training Data
%%  Initializing Parameter for the Simulink

% Parameters
A = 1;
h1init = 0;
h2init = 0;
h3init = 0;

Kv1to2 = 0.075;
Ktb1to2 = 0.0334;
Tube1to2onoff = 1; % 0=off; 1=on 

Kv2to3 = 0.075;
Ktb2to3 = 0.0334;
Tube2to3onoff = 1; % 0=off; 1=on

Kv1out = 0.02727;
Kv2out = 0.0045;
Kv3out = 0.02727;

% Data Preparation
totalTime = 2e5; % Total simulation time in seconds
minValue = 0; % Minimum step value (integer)
maxValue = 100; % Maximum step value (integer)

% Generate the step signal
stepSignal = generateStepSignal(totalTime, minValue, maxValue);
stepSignal = stepSignal / 100;

%% Convert in time series for the input in Simulink
% Create the time vector
timeVector = 0:(totalTime - 1); % Time vector

% Convert to timeseries object
stepSignalTimeseries = timeseries(stepSignal, timeVector);

% Plot the generated step signal
figure;
plot(stepSignalTimeseries, 'LineWidth', 1.5);
xlabel('Time');
ylabel('Value');
title('Generated Integer Step Signal with Fixed Step Duration');

% Run the Simulink model
simOut = sim('the3TankSim.slx', 'StopTime', num2str(totalTime));

%% Extract and plot the results
figure;
subplot(3,1,1);
plot(simOut.tout(1:50000), simOut.h1(1:50000), 'LineWidth', 1.5);
autoLabelPlot('Tank 1 Water Level', 'Time (s)', 'Water Level [%]')

subplot(3,1,2);
plot(simOut.tout(1:50000), simOut.h2(1:50000), 'LineWidth', 1.5);
autoLabelPlot('Tank 2 Water Level', 'Time (s)', 'Water Level [%]')

subplot(3,1,3);
plot(simOut.tout(1:50000), simOut.h3(1:50000), 'LineWidth', 1.5);
autoLabelPlot('Tank 3 Water Level', 'Time (s)', 'Water Level [%]')

% Extract variables from the Simulink output
h1 = simOut.get('h1');
h2 = simOut.get('h2');
h3 = simOut.get('h3');
tout = simOut.get('tout');

% Ensure all variables have the same length
minLength = min([length(tout), length(h1), length(h2), length(h3), length(stepSignal)]);

tout = tout(1:minLength);
h1 = h1(1:minLength);
h2 = h2(1:minLength);
h3 = h3(1:minLength);
stepSignal = stepSignal(1:minLength);

%% Save the training parameter and training data
% Save the data to a .mat file
save('myTankSimDatenTraining.mat','h1', 'h2', 'h3', 'stepSignal', 'tout')

% Save the parameters to a .mat file
save('tankParameters.mat', 'A', 'h1init', 'h2init', 'h3init', ...
    'Kv1to2', 'Ktb1to2', 'Tube1to2onoff', ...
    'Kv2to3', 'Ktb2to3', 'Tube2to3onoff', ...
    'Kv1out', 'Kv2out', 'Kv3out');

%% Test Data
%%
% Parameters
A = 1;
h1init = 10;
h2init = 10;
h3init = 10;

Kv1to2 = 0.075;
Ktb1to2 = 0.0334;
Tube1to2onoff = 1; % 0=off; 1=on 

Kv2to3 = 0.075;
Ktb2to3 = 0.0334;
Tube2to3onoff = 1; % 0=off; 1=on

Kv1out = 0.02727;
Kv2out = 0.0045;
Kv3out = 0.02727;

% Data Preparation
stepDuration = 1500; % Step duration in seconds

% Generate the step signal
stepSignal = generateFixedStepSignal(stepDuration);
stepSignal = stepSignal / 100;
totalTime = length(stepSignal);

% Create the time vector
timeVector = 0:(totalTime - 1); % Time vector

% Convert to timeseries object
stepSignalTimeseries = timeseries(stepSignal, timeVector);

% Run the Simulink model
simOut = sim('the3TankSim.slx', 'StopTime', num2str(totalTime));

% Extract variables from the Simulink output
h1 = simOut.get('h1');
h2 = simOut.get('h2');
h3 = simOut.get('h3');
tout = simOut.get('tout');

% Ensure all variables have the same length
minLength = min([length(tout), length(h1), length(h2), length(h3), length(stepSignal)]);

tout = tout(1:minLength);
h1 = h1(1:minLength);
h2 = h2(1:minLength);
h3 = h3(1:minLength);
stepSignal = stepSignal(1:minLength);


%% Extract and plot the results
figure;
subplot(3,1,1);
plot(tout, h1, 'LineWidth', 1.5);
autoLabelPlot('Tank 1 Water Level', 'Time (s)', 'Water Level [%]')

subplot(3,1,2);
plot(tout, h2, 'LineWidth', 1.5);
autoLabelPlot('Tank 2 Water Level', 'Time (s)', 'Water Level [%]')

subplot(3,1,3);
plot(tout, h3, 'LineWidth', 1.5);
autoLabelPlot('Tank 3 Water Level', 'Time (s)', 'Water Level [%]')

%% Save test data
% Save the data to a .mat file
save('myTankSimDatenTest.mat','h1', 'h2', 'h3', 'stepSignal', 'tout')

