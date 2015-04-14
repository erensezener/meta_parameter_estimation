function [ reduced_states, actions, rewards ] = get_ras( data )
%GET_RAS Given data from Mohammad's data, finds rs, as, ss

positions = data(:,1:4);
voltages = data(:,5);
number_of_states = 9;
number_of_actions = 4;

rewards = get_rewards(positions(:,4));
[ states,  state_borders] = discretize(positions, number_of_states);
reduced_states = reduce_state_dims(states, number_of_states);
[ actions,  action_borders] = discretize(voltages, number_of_actions);



end

