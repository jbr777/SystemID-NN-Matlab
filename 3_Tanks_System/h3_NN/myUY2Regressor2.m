function [in, out] = myUY2Regressor2(u, y, ny, nu, nd)

    % in - y(k-nd), y(k-1-nd), y(k-ny-nd+1), u(k-nd), u(k-1-nd), u(k-nu-nd+1)
    % out - y(k)
    
    % The maximum of past output lags (ny + nd) and past inputs considering delay (nd + nu)
    startIdx = max(ny + nd-1, nd + nu - 1) + 1;
    % Calculate the number of samples based on available data
    N = length(y) - startIdx + 1;

    % Pre-allocate for efficiency
    out = y(startIdx:end);
    in = zeros(N, ny + nu);

    % Fill in the data
    for k = 1:N
        idx = k + startIdx - 1;  % Current index in original data
        % Past output values with delay
        in(k, 1:ny) = y(idx-nd:-1:idx-nd-ny+1);
        % Past input values with delay
        in(k, ny+1:ny+nu) = u(idx-nd:-1:idx-nd-nu+1);
    end
end
