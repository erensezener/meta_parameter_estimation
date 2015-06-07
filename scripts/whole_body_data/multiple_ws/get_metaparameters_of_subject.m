function [ results ] = get_metaparameters_of_subject( sub_no )
%DISCRETIZE_ALL_TRIALS Summary of this function goes here
%   Detailed explanation goes here

load(strcat('./whole_body_data/','s', num2str(sub_no), 'mvc.mat'));

number_of_trials = 15;
weight_length = 1;

downsampling_rate = 50;
smoothing_rate = 51;

all_state_data = [];
all_action_data = [];
lengths = zeros(number_of_trials,1);

for i = 1:number_of_trials
    data = selection_lean(sub_no,i);
    
    CoM = data(:,3);
    
    %Clean outliers
    temp_CoM = CoM(CoM < 5000);
    CoM(CoM > 5000) = max(temp_CoM);
    temp_CoM = CoM(CoM > -5000);
    CoM(CoM < -5000) = min(temp_CoM);
    
    CoM = downsample(smooth(CoM,smoothing_rate), downsampling_rate);
    delta_CoM = diff(CoM); %this is 1 row shorter than CoM data
    F = downsample(smooth(data(:,2),smoothing_rate), downsampling_rate);
    state_data = [CoM(1:end-1,:), delta_CoM, F(1:end-1,:)];
    action_data = data(1:end,[end-1, end]); %emg data in this case
    action_data = [action_data(:,1)/MVC_noga(6), action_data(:,2)/MVC_noga(7)];
    action_data = [downsample(smooth(action_data(:,1)/MVC_noga(6),smoothing_rate), downsampling_rate), ...
        downsample(smooth(action_data(:,2)/MVC_noga(7),smoothing_rate), downsampling_rate)];
    action_data = action_data(1:end-1,:);
    
    all_state_data = [all_state_data; state_data];
    all_action_data = [all_action_data; action_data];
    lengths(i) = size(state_data,1);
end

number_of_states = 9; %per state dimension
number_of_actions = 5; %per state dimension

[ all_discrete_states, all_discrete_actions] = get_as( all_state_data, all_action_data, ...
    number_of_states, number_of_actions);

% all_rewards = get_rewards(all_action_data, all_state_data, 1);
max_states = max(all_state_data);
min_states = min(all_state_data);
max_actions = max(all_action_data);
min_actions = min(all_action_data);

results = cell(number_of_trials,1);
qs = cell(number_of_trials,1);
for i = 1:number_of_trials
    if i == 1
        states = all_discrete_states(1:lengths(i),:);
        actions = all_discrete_actions(1:lengths(i),:);
        state_data = all_state_data(1:lengths(i),:);
        action_data = all_action_data(1:lengths(i),:);
        
        number_of_estimated_states = max(all_discrete_states) + 1;
        number_of_estimated_actions = max(all_discrete_actions) + 1;
        q_prev = zeros(number_of_estimated_states, number_of_estimated_actions);
        metaparameters_prev = [0, 0, 0];
        weights_prev = zeros(1, weight_length);
        
        
    else
        begin_index = sum(lengths(1:i-1)) + 1;
        end_index = begin_index + lengths(i) - 1;
        
        states = all_discrete_states(begin_index:end_index,:);
        actions = all_discrete_actions(begin_index:end_index,:);
        state_data = all_state_data(begin_index:end_index,:);
        action_data = all_action_data(begin_index:end_index,:);        
        
    end
    
    [ alpha, beta, gamma, q_final, weights] = get_metaparameters_with_q(1, actions, states, q_prev, ...
        metaparameters_prev, weights_prev, state_data, action_data, max_states, min_states, max_actions, min_actions);
    
    
    results{i,1} =  [alpha, beta, gamma, weights];
    q_prev = q_final;
    weights_prev = weights;
    metaparameters_prev = [alpha, beta, gamma];
    qs{i,1} = q_prev;
end
end
