clc; clear all; close all;

% Load the data from a .mat file
load('myTankSimDatenTraining.mat', 'h1', 'h2', 'h3', 'stepSignal', 'tout')

% Load the parameters from a .mat file
load('tankParameters.mat', 'A', 'h1init', 'h2init', 'h3init', ...
    'Kv1to2', 'Ktb1to2', 'Tube1to2onoff', ...
    'Kv2to3', 'Ktb2to3', 'Tube2to3onoff', ...
    'Kv1out', 'Kv2out', 'Kv3out');

% Assuming myUY2Regressor is a function that generates features and targets
[f1, t1] = myUY2Regressor(stepSignal, h1, 1, 1, 1); %h1(k)=f(u(k-1),h1(k-1))
[f2, t2] = myUY2Regressor(stepSignal, h2, 1, 1, 1); %h2(k)=f(h3(k-1),h1(k-1), h2(k-1))
[f3, t3] = myUY2Regressor(stepSignal, h3, 1, 1, 1); %h3(k)=f(h2(k-1), h3(k-1))

% Separate input (u) and features for each tank
u = f1(:, 2);
f1 = f1(:, 1);
f2 = f2(:, 1);
f3 = f3(:, 1);

features = [f1 f2 f3 u];
targets = [t1 t2 t3];

% Loop over different configurations
for neurons = 10:10
    % Create the network with one hidden layer
    net = feedforwardnet(neurons);
    % net.trainFcn = trainFunction;

    % Set transfer functions
    net.layers{1}.transferFcn = 'tansig';
    net.layers{2}.transferFcn = 'purelin';

    % Set training options
    net.divideParam.trainRatio = 0.8;
    net.divideParam.valRatio = 0.2;
    net.divideParam.testRatio = 0;

    % Train the network
    [net, tr] = train(net, features', targets');

    % Save the trained model with a corresponding name
    filename = sprintf("net_%d_neurons_tansig.mat", neurons);
    save(filename, "net");

    fprintf('Trained and saved network with %d neurons in the hidden layer.\n', neurons);
end

% Shut down the parallel pool
% delete(gcp('nocreate'));

fprintf('Training and saving completed for all configurations.\n');
