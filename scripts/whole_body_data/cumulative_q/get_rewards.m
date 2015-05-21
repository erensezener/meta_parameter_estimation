function [ rewards ] = get_rewards( emg_values, state_values, weight )

len = length(emg_values);

%normalize
emg_values = bsxfun(@rdivide, bsxfun(@minus,emg_values,min(emg_values)), ...
    bsxfun(@minus,max(emg_values),min(emg_values)));

% cost_function = @(emg_value, delta_CoM) ...
%                     -norm(emg_value)^2 + weight * delta_CoM^2;

cost_function = @(emg_value, delta_CoM) -norm(emg_value)^2;

rewards = zeros(len,1);
delta_CoMs = state_values(:,2);

for i = 1:len
    rewards(i) = cost_function(emg_values(i,:), delta_CoMs(i,:));
end

% rewards = (rewards - min(rewards)) ./ (max(rewards) - min(rewards));
rewards = 1.5 - rewards;
end

