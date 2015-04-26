function [ downsampled_time_series_output ] = down_sample( time_series_input, sampling_rate )
%DOWNSAMPLE Summary of this function goes here
%   Detailed explanation goes here
[m, ~] = size(time_series_input);
indices_to_get = round(linspace(1, m, floor(m/sampling_rate))); %Using round is not proper
downsampled_time_series_output = time_series_input(indices_to_get, :);

end

