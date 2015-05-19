function [ rewards ] = get_rewards( emg_values, state_values, max_states, min_states, max_actions, min_actions, weight)

len = length(emg_values);

emg_values = normalize_btw_0_and_1(emg_values, max_actions, min_actions);

% cost_function = @(emg_value, delta_CoM) ...
%                     -norm(emg_value)^2 + weight * delta_CoM^2;


% delta_CoMs = state_values(:,2);
CoMs = state_values(:,1);
CoMs = normalize_btw_0_and_1(CoMs, max_states(1), min_states(1));
mean_CoM = mean(CoMs); %TODO get global mean
diff_CoMs = abs(CoMs - mean_CoM);
% diff_CoM = normalize_btw_0_and_1(diff_CoM, max_states(1), min_states(1));

% cost_function = @(emg_value, CoM, delta_CoM) - w(1) * emg_values(:,1) - w(2) * emg_values(:,2) ...
%     - w(3) * (mean_CoM - CoM) ^ 2 - w(4) * sign((CoM - mean_CoM)) * delta_CoM;

cost_function = @(emg_value) - emg_value(:,1) - weight * emg_value(:,2);
%     - weight(3) * diff_CoM;

rewards = zeros(len,1);


for i = 1:len
    rewards(i) = cost_function(emg_values(i,:));
end

rewards = - cost_function([1,1]) + rewards;
end

