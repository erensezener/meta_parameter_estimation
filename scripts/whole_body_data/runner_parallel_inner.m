function [] = runner_parallel_inner( sub_no, series_no )
%RUNNER_PARALLEL_INNER Summary of this function goes here
%   Detailed explanation goes here

load(strcat('./whole_body_data/','sub', num2str(sub_no), '.mat'));
load(strcat('./whole_body_data/','s', num2str(sub_no), 'mvc.mat'));

data = selection(sub_no, series_no, 0);
%% temp hack
data = data(1:1000, :);
weight = 1;

%%

CoM = data(:,6);
delta_CoM = diff(CoM); %this is 1 row shorter than CoM data
F = data(:,3);
state_data = [CoM(1:end-1,:), delta_CoM, F(1:end-1,:)];
action_data = data(1:end-1,[end-1, end]); %emg data in this case
action_data = [action_data(:,1)/MVC_noga(6), action_data(:,2)/MVC_noga(7)];
clear data;

% number_of_states = 8*9^3 + 8 * 9^2 + 8* 9^1 + 8 * 9^0; %a temporary hack
number_of_states = 9; %per state dimension
number_of_actions = 5; %per state dimension

[ states, actions, rewards ] = get_ras( state_data, action_data, ...
                                        number_of_states, number_of_actions, weight);

number_of_estimated_states = size(unique(states),1);
number_of_estimated_actions = size(unique(actions),1);
                                    
[ alpha, beta, gamma ] = get_metaparameters(actions', rewards, states, ...
    number_of_estimated_states, number_of_estimated_actions);
save(strcat('./results/run3/', filename_of_data));
end

