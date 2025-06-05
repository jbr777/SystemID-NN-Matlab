function y = generateFixedStepSignal(numDiscreteValuesPerStep)
    % Parameters:
    %   numDiscreteValuesPerStep - Number of discrete values per step
    %
    % Returns:
    %   y - Vector with step changes, containing specified values

    % Define the step values
    stepValues = [0, 40, 80, 100, 50, 30];
    numSteps = length(stepValues);
    
    % Calculate the total number of discrete values for the complete signal
    totalDiscreteValues = numSteps * numDiscreteValuesPerStep;
    
    % Initialize the output signal vector
    y = zeros(1, totalDiscreteValues);

    % Generate the step signal
    for step = 1:numSteps
        startIndex = (step - 1) * numDiscreteValuesPerStep + 1;
        endIndex = step * numDiscreteValuesPerStep;
        y(startIndex:endIndex) = stepValues(step);
    end
end
