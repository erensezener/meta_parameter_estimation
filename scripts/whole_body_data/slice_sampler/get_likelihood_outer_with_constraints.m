function [ log_likelihood ] = get_likelihood_outer_with_constraints( w, as, ss, initial_Q, ...
    state_data, action_data, max_states, min_states, max_actions, min_actions )
%GET_LIKELIHOOD_OUTER_WITH_CONSTRAINTS Gives 0 probability to points that
%lie outside of the constraints

gamma_range = [0.1, 0.999];
alpha_range = [0.1, 0.999];
beta_range = [-3, 1.5];
a_range = [-1, 1];
b_range = [0, 1];
a_plus_b_range = [0.01, 0.99];

w_extended = [w, w(4) + w(5)];

lower_bounds = [alpha_range(1), beta_range(1), gamma_range(1), a_range(1), b_range(1), a_plus_b_range(1)];
upper_bounds = [alpha_range(2), beta_range(2), gamma_range(2), a_range(2), b_range(2), a_plus_b_range(2)];

if nnz(w_extended > lower_bounds) < size(w_extended,2) || nnz(w_extended < upper_bounds) < size(w_extended,2)
    log_likelihood = -1 * realmax;
else
    log_likelihood = -1 * get_likelihood_and_q(as, ...
    get_rewards(action_data, state_data, max_states, min_states, max_actions, min_actions, [w(4),w(5)]), ...
    ss, w(1), exp(w(2)), w(3), initial_Q);
end

end

