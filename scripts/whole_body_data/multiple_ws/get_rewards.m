function [ rewards ] = get_rewards( emg_values, state_values, weight )

len = length(emg_values);

%normalize
emg_values = bsxfun(@rdivide, bsxfun(@minus,emg_values,min(emg_values)), ...
    bsxfun(@minus,max(emg_values),min(emg_values)));

% cost_function = @(emg_value, delta_CoM) ...
%                     -norm(emg_value)^2 + weight * delta_CoM^2;


delta_CoMs = state_values(:,2);
CoMs = state_values(:,1);

mean_CoM = mean(CoMs);

cost_function = @(emg_value, CoM, delta_CoM) - w(1) * emg_values(:,1) - w(2) * emg_values(:,2) ...
    - w(3) * (mean_CoM - CoM) ^ 2 - w(4) * sign((CoM - mean_CoM)) * delta_CoM;

rewards = zeros(len,1);


for i = 1:len
    rewards(i) = cost_function(emg_values(i,:), delta_CoMs(i,:));
end

rewards = (rewards - min(rewards)) ./ (max(rewards) - min(rewards));
end

