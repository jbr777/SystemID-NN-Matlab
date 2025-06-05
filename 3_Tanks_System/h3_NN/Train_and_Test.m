clc; clear all; close all;

%% Load the data from init3TankSim.m
% Load the data from a .mat file
load('myTankSimDatenTraining.mat', 'h1', 'h2', 'h3', 'stepSignal', 'tout');

% Load the parameters from a .mat file
load('tankParameters.mat', 'A', 'h1init', 'h2init', 'h3init', ...
    'Kv1to2', 'Ktb1to2', 'Tube1to2onoff', ...
    'Kv2to3', 'Ktb2to3', 'Tube2to3onoff', ...
    'Kv1out', 'Kv2out', 'Kv3out');

%% Prepare the features and the target for the neural network
[features, targets] = myUY2Regressor2(stepSignal, h3, 3, 3, 1);

%% Train the neural networks
for numLayers = 1:3
    for neurons = 10:20
        % Create the network with specified hidden layers
        hiddenLayerSizes = repmat(neurons, 1, numLayers);
        net = feedforwardnet(hiddenLayerSizes);

        % Set transfer functions
        for i = 1:numLayers
            net.layers{i}.transferFcn = 'tansig';
        end
        net.layers{end}.transferFcn = 'purelin';

        % Set training options
        net.divideParam.trainRatio = 0.8;
        net.divideParam.valRatio = 0.2;
        net.divideParam.testRatio = 0;
        net.trainParam.epochs = 500;

        % Train the network
        [net, tr] = train(net, features', targets');

        % Save the trained model with a corresponding name
        filename = sprintf("net_%d_layers_%d_neurons_tansig.mat", numLayers, neurons);
        save(filename, "net");

        fprintf('Trained and saved network with %d layers and %d neurons per layer.\n', numLayers, neurons);
    end
end

fprintf('Training and saving completed for all configurations.\n');

%% Load the data from init3TankSim.m for testing
% Load the data from a .mat file
load('myTankSimDatenTest.mat', 'h1', 'h2', 'h3', 'stepSignal', 'tout');

% Load the parameters from a .mat file
load('tankParameters.mat', 'A', 'h1init', 'h2init', 'h3init', ...
    'Kv1to2', 'Ktb1to2', 'Tube1to2onoff', ...
    'Kv2to3', 'Ktb2to3', 'Tube2to3onoff', ...
    'Kv1out', 'Kv2out', 'Kv3out');

%% Prepare the test data for the neural network
[inTest, outTest] = myUY2Regressor2(stepSignal, h3, 3, 3, 1);

%% Test Data
for numLayers = 1:3
    for neurons = 10:20
        % Load the trained network
        filename = sprintf("net_%d_layers_%d_neurons_tansig.mat", numLayers, neurons);
        if isfile(filename)
            net = load(filename, 'net').net;
        else
            fprintf('File %s not found. Skipping this configuration.\n', filename);
            continue;
        end

        %% Closed-Loop Forecasting
        outNN = zeros(length(outTest), 1); % Preallocate output array
        for k = 1:length(outTest)
            % Perform one-step-ahead prediction using the network
            outNN(k) = net(inTest(k, :)');
            if k < length(outTest)
                inTest(k+1, 1:3) = [outNN(k), inTest(k, 1:2)]; % Update inTest with the prediction
            end
        end

        % Calculate Test Error
        test_errors = sqrt(mean((outNN' - outTest).^2));
        fprintf('Test RMSE for %d layers and %d neurons: %.4f\n', numLayers, neurons, test_errors);

        % Plot results
        figure;
        plot(outNN, '--', 'DisplayName', sprintf('Close-Loop Prediction [%d layers, %d neurons]', numLayers, neurons), 'LineWidth', 1.5);
        hold on;
        plot(outTest, 'DisplayName', 'Target t3', 'LineWidth', 1.5);
        title(sprintf('Close Loop Forecasting [%d layers, %d neurons]', numLayers, neurons));
        xlabel('Time [s]');
        ylabel('Value');
        legend('Neural Network', 'Actual Output', 'Location', 'southeast');
        hold off;

        % Save the plot
        plotFilename = sprintf('CloseLoopForecasting_%d_layers_%d_neurons.png', numLayers, neurons);
        saveas(gcf, plotFilename);

        fprintf('Closed-loop forecasting completed and saved for network with [%d layers, %d neurons].\n', numLayers, neurons);
    end
end

fprintf('Closed-loop forecasting and saving completed for all configurations.\n');
