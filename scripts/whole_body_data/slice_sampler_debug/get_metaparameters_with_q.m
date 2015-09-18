function [history] = get_metaparameters_with_q(as, ss, initial_Q, ...
    state_data, action_data, max_states, min_states, max_actions, min_actions, width_coeff)
%Does MCMC simulation to find the most likely metaparameters

% get_likelihood_outer = @(w) -1 * get_likelihood_and_q(as, ...
%     get_rewards(action_data, state_data, max_states, min_states, max_actions, min_actions, [w(4),w(5)]), ...
%     ss, w(1), exp(w(2)), w(3), initial_Q);
% 
% history = slicesample([0.5, 0.1, 0.5, 0.2, 0.2]',1000,'logpdf',get_likelihood_outer);

get_likelihood_outer_wrapped = @(w) get_likelihood_outer_with_constraints( w, as, ss, initial_Q, ...
    state_data, action_data, max_states, min_states, max_actions, min_actions );

width = width_coeff * [1, 1, 1, 1, 1];
history = slicesample([0.2, -0.1, 0.57, 0.01, 0.5]', 12000,'logpdf',get_likelihood_outer_wrapped, 'width', width);


end
