clc; close all; clear all;

%% Generate data
[u1] = generateStepSignal(2e4, -5, 5);
[y1, y1N] = simPT2(u1); 

%% Prepare Regressors
ny = 2; 
nu = 2; 
nd = 1; 
% Preparation of the data to feed into the neural network.
[features, targets] = myUY2Regressor(u1, y1N, ny, nu, nd); 

%% Define Fibonacci Series
fibonacci_series = [1, 2]; % Initialize with the first two numbers
for i = 3:10 % Generate the Fibonacci series up to the 7th number
    fibonacci_series(i) = fibonacci_series(i-1) + fibonacci_series(i-2);
end

%% Create and Train Networks
networks = cell(1, length(fibonacci_series)); % Initialize a cell array to store networks
num_neurons = zeros(1, length(fibonacci_series)); % Initialize an array to store the number of neurons
training_errors = zeros(1, length(fibonacci_series)); % Initialize an array to store training errors

for i = 1:length(fibonacci_series)
    % Define Network
    num_neurons(i) = fibonacci_series(i); % Store the number of neurons
    net = feedforwardnet(num_neurons(i));
    net.layers{1}.transferFcn = 'tansig';
    net.layers{end}.transferFcn = 'purelin';
    net.divideParam.trainRatio = 1; % Use all data for training
    net.divideParam.valRatio = 0; % Use all data for training
    net.divideParam.testRatio = 0; % Use all data for training

    % Compute Standardization Parameters and Standardize Training Data
    mu_x = mean(features, 1);
    sigma_x = std(features, 0, 1);
    mu_y = mean(targets);
    sigma_y = std(targets);

    x_train_std = (features - mu_x) ./ sigma_x;
    y_train_std = (targets - mu_y) / sigma_y;

    % Train Network
    [net, tr] = train(net, x_train_std', y_train_std');
    networks{i} = net;

    % Compute Training Error (RMSE)
    y_train_pred_std = net(x_train_std')';
    y_train_pred = y_train_pred_std * sigma_y + mu_y;
    training_errors(i) = sqrt(mean((targets - y_train_pred).^2));

    % Print Training Error
    fprintf(['Training Error (RMSE) for Network with %d Neuron(s) in Hidden ' ...
        'Layer: %.6f\n'], num_neurons(i), training_errors(i));
    
    % Save Network
    save_path = sprintf('network_%d_neurons.mat', num_neurons(i));
    save(save_path, 'networks', 'mu_x', 'sigma_x', 'mu_y', 'sigma_y', ...
        'num_neurons', 'training_errors', '-v7.3');
end

%% Plot Training Errors
figure;
plot(num_neurons, training_errors, '-o');
title('Training Error (RMSE) vs. Number of Neurons in Hidden Layer');
xlabel('Number of Neurons in Hidden Layer');
ylabel('Training Error (RMSE)');
grid on;

