function [alpha, beta, gamma, weight] = runner_parallel_inner( sub_no, series_no )
%RUNNER_PARALLEL_INNER Summary of this function goes here
%   Detailed explanation goes here

load(strcat('./whole_body_data/','sub', num2str(sub_no), '.mat'));
load(strcat('./whole_body_data/','s', num2str(sub_no), 'mvc.mat'));

data = selection(sub_no, series_no, 0);

CoP = downsample(smooth(data(:,4),11), 10);
delta_CoP = diff(CoP); %this is 1 row shorter than CoM data
F = downsample(smooth(data(:,3),11), 10);
state_data = [CoP(1:end-1,:), delta_CoP, F(1:end-1,:)];
action_data = data(1:end,[end-1, end]); %emg data in this case
action_data = [action_data(:,1)/MVC_noga(6), action_data(:,2)/MVC_noga(7)];
action_data = [downsample(smooth(action_data(:,1)/MVC_noga(6),11), 10), ...
    downsample(smooth(action_data(:,2)/MVC_noga(7),11), 10)];
action_data = action_data(1:end-1,:);

clear data;

% number_of_states = 8*9^3 + 8 * 9^2 + 8* 9^1 + 8 * 9^0; %a temporary hack
number_of_states = 9; %per state dimension
number_of_actions = 5; %per state dimension

[ states, actions] = get_as( state_data, action_data, ...
                                        number_of_states, number_of_actions);

number_of_estimated_states = size(unique(states),1);
number_of_estimated_actions = size(unique(actions),1);
                                    
[ alpha, beta, gamma, weight ] = get_metaparameters_and_rewards(actions', states, state_data, action_data, ...
    number_of_estimated_states, number_of_estimated_actions);
% save(strcat('./results/whole_body/', filename_of_data));
end

