function autoLabelPlot(titleStr, xLabelStr, yLabelStr)

    titleFontSize=16;
    labelFontSize=14;
    % Set the title with LaTeX formatting
    title(titleStr, 'FontSize', titleFontSize);
    % Set the x-axis label with LaTeX formatting
    xlabel(xLabelStr, 'FontSize', labelFontSize);
    % Set the y-axis label with LaTeX formatting
    ylabel(yLabelStr, 'FontSize', labelFontSize);
    grid on
    
end

