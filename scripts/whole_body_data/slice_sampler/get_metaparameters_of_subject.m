function [history ] = get_metaparameters_of_subject( sub_no )
%DISCRETIZE_ALL_TRIALS Summary of this function goes here
%   Detailed explanation goes here

load(strcat('./whole_body_data/','s', num2str(sub_no), 'mvc.mat'));

number_of_trials = 15;

downsampling_rate = 50;
smoothing_rate = 51;

data = selection_lean(sub_no,1); %to learn the size
all_data = zeros(size(data,1)*number_of_trials, size(data,2));

last_free_index = 1;
for i = 1:number_of_trials
    data = selection_lean(sub_no,i);
    data_length = size(data,1);
    all_data(last_free_index:last_free_index + data_length-1, :) = data;
    last_free_index = last_free_index + data_length;
end

CoM = all_data(:,3);

%Clean outliers
temp_CoM = CoM(CoM < 5000);
CoM(CoM > 5000) = max(temp_CoM);
temp_CoM = CoM(CoM > -5000);
CoM(CoM < -5000) = min(temp_CoM);

CoM = downsample(smooth(CoM,smoothing_rate), downsampling_rate);
delta_CoM = diff(CoM); %this is 1 row shorter than CoM data
F = downsample(smooth(all_data(:,2),smoothing_rate), downsampling_rate);
state_data = [CoM(1:end-1,:), delta_CoM, F(1:end-1,:)];
action_data = all_data(1:end,[end-1, end]); %emg data in this case
action_data = [action_data(:,1)/MVC_noga(6), action_data(:,2)/MVC_noga(7)];
action_data = [downsample(smooth(action_data(:,1)/MVC_noga(6),smoothing_rate), downsampling_rate), ...
    downsample(smooth(action_data(:,2)/MVC_noga(7),smoothing_rate), downsampling_rate)];
action_data = action_data(1:end-1,:);


number_of_states = 9; %per state dimension
number_of_actions = 5; %per state dimension

[ states, actions] = get_as( state_data, action_data, number_of_states, number_of_actions);

max_states = max(state_data);
min_states = min(state_data);
max_actions = max(action_data);
min_actions = min(action_data);

number_of_estimated_states = max(states) + 1;
number_of_estimated_actions = max(actions) + 1;
initial_q = zeros(number_of_estimated_states, number_of_estimated_actions);

[history] = get_metaparameters_with_q(actions, states, initial_q, ...
    state_data, action_data, max_states, min_states, max_actions, min_actions);

end