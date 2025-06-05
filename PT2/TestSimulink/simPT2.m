function [out, outN001] = simPT2(input)
    % Parameters:
    %   input - Vector representing the input signal to the PT2 system
    %
    % Returns:
    %   out - Vector containing the simulated output of the PT2 system 
    %   outN001 - Vector similar to out but with added Gaussian noise

    % Parameters for the PT2 system
    w0 = 1;           % Natural frequency
    D = 0.707;        % Damping ratio
    
    % Transfer function of the PT2 system
    s = tf('s');
    sys = 1/((1/w0)^2*s^2+2*D/w0*s+1);
    Gz = c2d(sys, 0.05)

    % Simulate the plant using lsim
    out   = lsim(Gz, input);
    N=length(input);
    rng('default')
    outN001  = out + 0.001*randn(N,1);

end