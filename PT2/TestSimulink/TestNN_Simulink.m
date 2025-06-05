clc; clear all; close all;

%% Simulink Setting

net = load("myNetV3_19.mat").net;
% Parameters for the PT2 system
w0 = 1;           % Natural frequency
D = 0.707;        % Damping ratio

% Define the sampling frequency (in seconds)
samplingFrequency = 0.05; 

% Input types
inputTypes = {'Step', 'Ramp', 'Sine'};

%%
% Loop control values: -1 for open loop, positive for closed loop
loopTypes = [-1, 1]; 

for loopIdx = 1:length(loopTypes)
    Loop = loopTypes(loopIdx);
    
    % Create a new figure for each loop type
    figure;
    
    for typeIdx = 1:length(inputTypes)
        type = typeIdx; % 1 - Step, 2 - Ramp, 3 - Sine
        
        % Simulate the model with specified solver options
        simOut = sim('SimulinkBlockNN', 'Solver', 'FixedStepAuto', ...
                     'FixedStep', num2str(samplingFrequency));

        %% Extraction of Simulink variables
        tvec = simOut.get('tout');
        uk  = simOut.get('uk');
        yk_sys = simOut.get('yk_theory');
        yk_NN  = simOut.get('yk_NN');
        inputData = simOut.get('InputData');

        %% Plot of Test (Simulink)
        subplot(3, 1, typeIdx);
        plot(tvec, uk, 'LineWidth',  1.5);
        hold on;
        plot(tvec, yk_NN, 'LineStyle', '--', 'LineWidth', 1.5);
        plot(tvec, yk_sys, 'LineWidth',  1.5);
        legend("Eingang", "NN", "Modell", 'FontSize', 10);
        if Loop > 0
            title([inputTypes{typeIdx}, " - Close Loop"], 'FontSize', 16);
        else
            title([inputTypes{typeIdx}, " - Open Loop"], 'FontSize', 16);
        end
        xlabel('Time [s]', 'FontSize', 14);
        ylabel('Value', 'FontSize', 14);
        grid on;
    end
end

legend("Eingang", "NN", "Modell", 'FontSize', 14);
