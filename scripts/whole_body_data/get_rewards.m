function [ rewards ] = get_rewards( emg_values, state_values, weight )

len = length(emg_values);
cost_function = @(emg_value, delta_CoM) ...
                    -norm(emg_value)^2 + weight * delta_CoM^2;
                
rewards = zeros(len,1);
delta_CoMs = state_values(:,2);

for i = 1:len
    rewards(i) = cost_function(emg_values(i,:), delta_CoMs(i,:));
end
end

