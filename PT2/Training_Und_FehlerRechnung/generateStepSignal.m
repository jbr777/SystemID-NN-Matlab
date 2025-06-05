function y = generateStepSignal(numElements, minValue, maxValue)
    % Parameters:
    %   numElements - Total number of elements in the signal
    %   minValue - Minimum value of the step
    %   maxValue - Maximum value of the step
    %
    % Returns:
    %   y - Vector with step changes

    % Initialize the output signal vector
    y = zeros(1, numElements);

    % Start with an initial random value within the range
    currentStep = minValue + (maxValue - minValue) * rand();
    y(1) = currentStep;

    % Initialize step point at the beginning of the array
    currentPoint = 1;

    % Generate step changes at random points until the end of the array
    while currentPoint < numElements
        % Random step duration between 70 and 100 samples
        stepDuration = randi([70, 100]);
        nextPoint = currentPoint + stepDuration;

        % Ensure the next step point does not exceed numElements
        nextPoint = min(nextPoint, numElements);

        % Apply the current step value to the range in the signal
        y(currentPoint:nextPoint-1) = currentStep;

        % Update current point to new location and generate new step value
        currentPoint = nextPoint;
        if currentPoint <= numElements
            currentStep = minValue + (maxValue - minValue) * rand();
        end
    end
end
