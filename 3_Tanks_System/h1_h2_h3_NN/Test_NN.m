clc;
close all;
clear all;

%%
% Load the data from a .mat file
load('myTankSimDatenTest.mat', 'h1', 'h2', 'h3', 'stepSignal', 'tout')

% Load the parameters from a .mat file
load('tankParameters.mat', 'A', 'h1init', 'h2init', 'h3init', ...
    'Kv1to2', 'Ktb1to2', 'Tube1to2onoff', ...
    'Kv2to3', 'Ktb2to3', 'Tube2to3onoff', ...
    'Kv1out', 'Kv2out', 'Kv3out');

%%
% Assuming myUY2Regressor is a function that generates features and targets
[f1, t1] = myUY2Regressor(stepSignal, h1, 1, 1, 1);
[f2, t2] = myUY2Regressor(stepSignal, h2, 1, 1, 1);
[f3, t3] = myUY2Regressor(stepSignal, h3, 1, 1, 1);

% Separate input (u) and features for each tank
u = f1(:, 2);
f1 = f1(:, 1);
f2 = f2(:, 1);
f3 = f3(:, 1);

inTest = [f1 f2 f3 u];
outTest = [t1 t2 t3];

%% 

% Loop over different configurations
for i = 10:10
        % Load the trained network
        filename = sprintf("net_%d_neurons_tansig.mat", i);
        if isfile(filename)
            net = load(filename, 'net').net;
        else
            fprintf('File %s not found. Skipping this configuration.\n', filename);
            continue;
        end

        %% Closed-Loop Forecasting
        outNN = zeros(length(tout)-1, 3); % Preallocate output array
        
        for k = 1:length(tout)-1
            % Perform one-step-ahead prediction using the network.
            outNN(k, :) = net(inTest(k, :)');
            inTest(k+1, 1:3) = outNN(k, 1:3); % Update inTest with the prediction
        end
        
        % Close-loop predictions plot
        figure;
        hold on;
        grid on;
        plot(outTest(:, 1), 'r', 'DisplayName', 'Target t1', 'LineWidth', 1.5);
        plot(outNN(:, 1), 'b--', 'DisplayName', sprintf('Close-Loop Prediction t1 [%d]', i), 'LineWidth', 1.5);
        plot(outTest(:, 2), 'g', 'DisplayName', 'Target t2');
        plot(outNN(:, 2), 'm--', 'DisplayName', sprintf('Close-Loop Prediction t2 [%d]', i), 'LineWidth', 1.5);
        plot(outTest(:, 3), 'k', 'DisplayName', 'Target t3');
        plot(outNN(:, 3), 'c--', 'DisplayName', sprintf('Close-Loop Prediction t3 [%d]', i), 'LineWidth', 1.5);
        legend;
        autoLabelPlot('Close-Loop Forecasting [10]', 'Time [s]', 'Value')
        hold off;

        % Save the plot
        plotFilename = sprintf('CloseLoopForecasting_%d_neurons.png', i);
        saveas(gcf, plotFilename);

        fprintf('Closed-loop forecasting completed and saved for network with [%d] neurons per layer.\n', i);
end

fprintf('Closed-loop forecasting and saving completed for all configurations.\n');