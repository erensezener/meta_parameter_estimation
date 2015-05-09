function [alpha, beta, gamma, q_final] = runner_parallel_inner( sub_no, series_no, q_initial)
%RUNNER_PARALLEL_INNER Summary of this function goes here
%   Detailed explanation goes here

load(strcat('./whole_body_data/','s', num2str(sub_no), 'mvc.mat'));

downsampling_rate = 10;
smoothing_rate = 11;
weight = 1;

data = selection_lean(sub_no, series_no);

CoP = downsample(smooth(data(:,3),smoothing_rate), downsampling_rate);
delta_CoP = diff(CoP); %this is 1 row shorter than CoM data
F = downsample(smooth(data(:,2),smoothing_rate), downsampling_rate);
state_data = [CoP(1:end-1,:), delta_CoP, F(1:end-1,:)];
action_data = data(1:end,[end-1, end]); %emg data in this case
action_data = [action_data(:,1)/MVC_noga(6), action_data(:,2)/MVC_noga(7)];
action_data = [downsample(smooth(action_data(:,1)/MVC_noga(6),smoothing_rate), downsampling_rate), ...
    downsample(smooth(action_data(:,2)/MVC_noga(7),smoothing_rate), downsampling_rate)];
action_data = action_data(1:end-1,:);

clear data; clear CoP; clear F; clear delta_CoP;

number_of_states = 9; %per state dimension
number_of_actions = 5; %per state dimension

[ states, actions] = get_as( state_data, action_data, ...
    number_of_states, number_of_actions);

%number_of_estimated_states = size(unique(states),1);
%number_of_estimated_actions = size(unique(actions),1);
number_of_estimated_states = max(states) + 1;
number_of_estimated_actions = max(actions) + 1;

rs = get_rewards(action_data, state_data, weight);

[ alpha, beta, gamma, q_final ] = get_metaparameters_with_q(actions, rs, ...
    states, number_of_estimated_states, number_of_estimated_actions, q_initial);


end
