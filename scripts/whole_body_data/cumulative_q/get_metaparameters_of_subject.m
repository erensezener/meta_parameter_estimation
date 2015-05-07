function [ results ] = get_metaparameters_of_subject( sub_no )
%DISCRETIZE_ALL_TRIALS Summary of this function goes here
%   Detailed explanation goes here

load(strcat('./whole_body_data/','s', num2str(sub_no), 'mvc.mat'));

number_of_trials = 15;

downsampling_rate = 100;
smoothing_rate = 101;

all_state_data = [];
all_action_data = [];
lengths = zeros(number_of_trials,1);

for i = 1:number_of_trials
    data = selection_lean(sub_no,i);
    
    CoP = downsample(smooth(data(:,3),smoothing_rate), downsampling_rate);
    delta_CoP = diff(CoP); %this is 1 row shorter than CoM data
    F = downsample(smooth(data(:,2),smoothing_rate), downsampling_rate);
    state_data = [CoP(1:end-1,:), delta_CoP, F(1:end-1,:)];
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

all_rewards = get_rewards(all_action_data, all_state_data, 1);

results = cell(number_of_trials,1);
qs = cell(number_of_trials,1);
for i = 1:number_of_trials
    if i == 1
        states = all_discrete_states(1:lengths(i),:);
        actions = all_discrete_actions(1:lengths(i),:);
        rewards = all_rewards(1:lengths(i),:);
        
        number_of_estimated_states = max(all_discrete_states) + 1;
        number_of_estimated_actions = max(all_discrete_actions) + 1;
        q_prev = zeros(number_of_estimated_states, number_of_estimated_actions);
        
        [ alpha, beta, gamma, q_final ] = get_metaparameters_with_q(actions, rewards, ...
            states, q_prev);
        
    else
        begin_index = sum(lengths(1:i-1)) + 1;
        end_index = begin_index + lengths(i) - 1;
        
        states = all_discrete_states(begin_index:end_index,:);
        actions = all_discrete_actions(begin_index:end_index,:);
        rewards = all_rewards(begin_index:end_index,:);
        
        [ alpha, beta, gamma, q_final ] = get_metaparameters_with_q(actions, rewards, ...
            states, q_prev);

    end
    
    results{i,1} =  [ alpha, beta, gamma ];
    q_prev = q_final;
    qs{i,1} = q_prev;
end


end

