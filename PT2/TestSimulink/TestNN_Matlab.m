clc; clear all; close all;

%% Step Signal 
[u] = generateStepSignal(1000, 0, 2); 
[ySt, yStN] = simPT2(u);

figure 
plot(u, 'LineWidth', 1.5)
autoLabelPlot('Zufällige Steps', 'Time [s]', 'Value')
grid on
%% Sinus Signal 
abs = 0.01; 
t = 1:abs:10; 
f = 1; 
uSin = 5 * sin(2 * pi * f * t); 
[ySin, ySinN] = simPT2(uSin);

%% Ramp Signal Generation
uRamp = 2 * t; 
[yRamp, yRampN] = simPT2(uRamp);

%% Preparing the data for Network Testing

% Preparation of the data to feed into the neural network.
[inTest, outTest] = myUY2Regressor(u, ySt, 2, 2, 1); 

%% Load Trained Network and Predict
% Load the trained network from a .mat file.
net = load("myNetV3_19.mat").net;

for k = 1:size(inTest, 1)
    outNN(k) = net(inTest(k, :)'); % Perform one-step-ahead prediction using the network.
    % Update the input matrix to include the new prediction for recursive forecasting. 
    % (Close Loop Forecasting)
    inTest(k + 1, 1:2) = [outNN(k) inTest(k, 1)]; 
end
outNN = outNN'; % Transpose for consistency with MATLAB plotting functions.

%% Plotting Results
figure; 
plot(outNN,'LineWidth',1.5);
autoLabelPlot('Close-Loop Forecasting [5]', 'Time [s]', 'Value');
hold on; 
plot(outTest, '--','LineWidth',1.5); 
legend('Output Neural Network', 'Output PT2-System')
grid on