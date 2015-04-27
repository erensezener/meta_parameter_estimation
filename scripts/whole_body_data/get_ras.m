function [ reduced_states, reduced_actions, rewards ] = get_ras( state_data, action_data, number_of_states, number_of_actions, weight)
%GET_RAS Given data from JSI experiments, finds rs, as, ss

rewards = get_rewards(action_data, state_data, weight);

[ states,  ~] = discretize(state_data, number_of_states);
reduced_states = reduce_state_dims(states, number_of_states);

[ actions,  ~] = discretize(action_data, number_of_actions);
reduced_actions = reduce_state_dims(actions, number_of_actions);

end

