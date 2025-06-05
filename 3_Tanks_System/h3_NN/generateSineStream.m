function [input, time] = generateSineStream(Abtastzeit, w_start, w_ende)

    ts = Abtastzeit;
    w_st = w_start;
    w_end = w_ende;

    sineStream = frest.createFixedTsSinestream(ts, {w_st, w_end});
    timeSeries_SS = generateTimeseries(sineStream);
    input = timeSeries_SS.Data;
    time = timeSeries_SS.Time;
    
end
