function [ rewards ] = get_rewards( thetas )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

len = length(thetas);
cost_function = @(theta) 1 + cos(theta);
rewards = zeros(len,1);

for i = 1:len
    rewards(i) = cost_function(thetas(i));
end
end

