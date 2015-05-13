function [ rewards ] = get_rewards( emg_values, state_values, weight )

len = length(emg_values);

emg_values = normalize_btw_0_and_1(emg_values);

% cost_function = @(emg_value, delta_CoM) ...
%                     -norm(emg_value)^2 + weight * delta_CoM^2;


% delta_CoMs = state_values(:,2);
CoMs = state_values(:,1);

mean_CoM = mean(CoMs);
diff_CoM = CoM - mean_CoM;
diff_CoM = normalize_btw_0_and_1(diff_CoM);

% cost_function = @(emg_value, CoM, delta_CoM) - w(1) * emg_values(:,1) - w(2) * emg_values(:,2) ...
%     - w(3) * (mean_CoM - CoM) ^ 2 - w(4) * sign((CoM - mean_CoM)) * delta_CoM;

cost_function = @(emg_value, diff_CoM) - weight(1) * emg_values(:,1) - weight(2) * emg_values(:,2) ...
    - weight(3) * diff_CoM;

rewards = zeros(len,1);


for i = 1:len
    rewards(i) = cost_function(emg_values(i,:), diff_CoM(i,:));
end

rewards = (rewards - min(rewards)) ./ (max(rewards) - min(rewards));
end

