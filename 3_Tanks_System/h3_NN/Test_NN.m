clc; clear all; close all;

%% Load the data from init3TankSim.m
% Load the data from a .mat file
load('myTankSimDatenTest.mat', 'h1', 'h2', 'h3', 'stepSignal', 'tout')

% Load the parameters from a .mat file
load('tankParameters.mat', 'A', 'h1init', 'h2init', 'h3init', ...
    'Kv1to2', 'Ktb1to2', 'Tube1to2onoff', ...
    'Kv2to3', 'Ktb2to3', 'Tube2to3onoff', ...
    'Kv1out', 'Kv2out', 'Kv3out');

%% Preapare the test data for the neural network
[inTest, outTest] = myUY2Regressor2(stepSignal, h3, 3, 3, 1);

%% Test Data
% Loop over different configurations
for i = 18:18
        % Load the trained network
        filename = sprintf("net_18_neurons_tansig.mat"); 
        if isfile(filename)
            net = load(filename, 'net').net;
        else
            fprintf('File %s not found. Skipping this configuration.\n', filename);
            continue;
        end

        %% Closed-Loop Forecasting
        
        for k = 1:length(outTest)
            % Perform one-step-ahead prediction using the network.
            outNN(k) = net(inTest(k, :)');
            inTest(k+1, 1:3) = [outNN(k), inTest(k, 1:2)]; % Update inTest with the prediction
        end
        
        % Calculate Test Error
        test_errors = sqrt(mean((outNN' - outTest).^2))

        figure 
        plot(outNN, '--', 'DisplayName', sprintf('Close-Loop Prediction t3 [%d]', i), 'LineWidth', 1.5)
        hold on
        plot(outTest,'DisplayName', 'Target t3', 'LineWidth', 1.5)
        autoLabelPlot('Close Loop Forecasting 18 neurons', 'Time [s]', 'Value')
        hold off
        legend('Neural Network', 'Actual Output', 'Location', 'southeast')

        % Save the plot
        plotFilename = sprintf('CloseLoopForecasting_%d_neurons.png', i);
        saveas(gcf, plotFilename);

        fprintf('Closed-loop forecasting completed and saved for network with [%d] neurons per layer.\n', i);
end

fprintf('Closed-loop forecasting and saving completed for all configurations.\n');