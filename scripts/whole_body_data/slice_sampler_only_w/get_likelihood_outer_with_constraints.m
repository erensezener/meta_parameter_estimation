function [ log_likelihood ] = get_likelihood_outer_with_constraints( w, as, ss, initial_Q, ...
    state_data, action_data, max_states, min_states, max_actions, min_actions )
%GET_LIKELIHOOD_OUTER_WITH_CONSTRAINTS Gives 0 probability to points that
%lie outside of the constraints

gamma = 0.4;
alpha = 0.25;
beta = 0.3;

a_range = [-1, 1];
b_range = [0, 1];
a_plus_b_range = [0.01, 0.99];

w_extended = [w, w(1) + w(2)];

lower_bounds = [a_range(1), b_range(1), a_plus_b_range(1)];
upper_bounds = [a_range(2), b_range(2), a_plus_b_range(2)];

if nnz(w_extended > lower_bounds) < size(w_extended,2) || nnz(w_extended < upper_bounds) < size(w_extended,2)
    log_likelihood = -1 * realmax;
else
    log_likelihood = -1 * get_likelihood_and_q(as, ...
    get_rewards(action_data, state_data, max_states, min_states, max_actions, min_actions, [w(1),w(2)]), ...
    ss, alpha, exp(beta), gamma, initial_Q);
end

end