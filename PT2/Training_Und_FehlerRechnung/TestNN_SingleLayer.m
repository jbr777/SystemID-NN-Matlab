clc; clear all; close all;

%% Step Signal 
[u] = generateStepSignal(1000, 0, 5); 
[ySt, yStN] = simPT2(u);

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

%% Define Fibonacci Series
fibonacci_series = [1, 2]; % Initialize with the first two numbers
for i = 3:10 % Generate the Fibonacci series up to the 7th number
    fibonacci_series(i) = fibonacci_series(i-1) + fibonacci_series(i-2);
end

%% Test Networks
test_errors = zeros(1, length(fibonacci_series));
training_errors = zeros(1, length(fibonacci_series));
num_neurons = zeros(1, length(fibonacci_series));

for i = 1:length(fibonacci_series)
    num_neurons_current = fibonacci_series(i);
    
    % Load the trained network from a .mat file.
    load(sprintf('network_%d_neurons.mat', num_neurons_current), ...
        'networks', 'mu_x', 'sigma_x', 'mu_y', 'sigma_y', 'num_neurons', ...
        'training_errors');
    net = networks{i};
   
    % Standardize test data
    x_test_std = (inTest - mu_x) ./ sigma_x;
    y_test_std = (outTest - mu_y) / sigma_y;
    
    % Predict
    outNN_std = zeros(size(x_test_std, 1), 1);
    outNN = zeros(size(x_test_std, 1), 1);
    
    for k = 1:size(x_test_std, 1)
        outNN_std(k) = net(x_test_std(k, :)');

        % Update the input matrix for recursive forecasting
        x_test_std(k + 1, 1:2) = [outNN_std(k) x_test_std(k, 1)];
    end

    outNN = outNN_std * sigma_y + mu_y; % De-standardize predicted outputs
  
    % Calculate Test Error
    test_errors(i) = sqrt(mean((outNN - outTest).^2));
    
    % Plotting Results
    figure;
    plot(outNN, 'LineWidth', 1.5);
    hold on;
    plot(outTest, '--', 'LineWidth', 1.5);
    title(sprintf('Network with %d Neuron(s) in Hidden Layer', ...
        num_neurons_current));
    legend('Predicted Output', 'Actual Output', 'Location', 'southeast');
    grid on;
    fprintf(['Test Error for Network with %d Neuron(s) in Hidden ' ...
        'Layer: %.6f\n'], num_neurons_current, test_errors(i));
end

%%
% Plot training and test errors
figure;
subplot(211)
plot(num_neurons, training_errors, '-o', 'LineWidth', 1.5);
autoLabelPlot('Training Errors', 'Number of Neurons in Hidden Layer','RMSE' )

subplot(212)
plot(num_neurons, test_errors, '-x', 'LineWidth', 1.5);
autoLabelPlot('Test Errors', 'Number of Neurons in Hidden Layer','RMSE' )

