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

%% Define and Train Network
% Create a feedforward neural network with three hidden layers, each containing 5 neurons.
net = feedforwardnet(5);
net.layers{1}.transferFcn = 'tansig'; 
net.layers{2}.transferFcn = 'purelin'; 
net.divideParam.trainRatio = 0.7; 
net.divideParam.valRatio = 0.15; 
net.divideParam.testRatio = 0.15; 

% Train the network using the generated features and targets.
net = train(net, features', targets'); 

%% Save Models
save("myNetV3_19.mat", "net");
