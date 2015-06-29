function [ alpha, beta, gamma, Q, weights, history] = get_metaparameters_with_q(trial_no, as, ss, initial_Q, initial_metaparameters, ...
    initial_weights, state_data, action_data, max_states, min_states, max_actions, min_actions)
%Does MCMC simulation to find the most likely metaparameters

gamma_range = [0.1, 0.999];
alpha_range = [0.1, 0.999];
beta_range = [-3, 1.5];
weight_range = [0.1, 0.99];

if trial_no == 1
    number_of_iterations = 30000;
    prior = @(metaparameters, weights) 1;
    step_size = 0.1;
else
    number_of_iterations = 8000;
    prior = @(metaparameters, weights) - log(normpdf(metaparameters, initial_metaparameters, 0.1*ones(1,3))) ...
        - log(normpdf(weights, initial_weights, 0.1));
    step_size = 0.1;
end

history = zeros(number_of_iterations, 4);

% get range lengths
alpha_range_length = (alpha_range(2) - alpha_range(1));
beta_range_length = (beta_range(2) - beta_range(1));
gamma_range_length = (gamma_range(2) - gamma_range(1));
weight_range_length = (weight_range(2) - weight_range(1));

% get lower and upper bounds
lower_bounds = [alpha_range(1), beta_range(1), gamma_range(1), weight_range(1)];
upper_bounds = [alpha_range(2), beta_range(2), gamma_range(2), weight_range(2)];

% get initial values
if nnz(initial_metaparameters) == 0 %all are zeros
    alpha = alpha_range_length * rand(1) + alpha_range(1);
    beta = beta_range_length * rand(1) + beta_range(1);
    gamma = gamma_range_length * rand(1) + gamma_range(1);
else
    alpha = initial_metaparameters(1);
    beta = initial_metaparameters(2);
    gamma = initial_metaparameters(3);
end

if nnz(initial_weights) == 0 %all are zeros
    weights = weight_range_length * rand(1) + weight_range(1);
else
    weights = initial_weights;
end

rs = get_rewards(action_data, state_data, max_states, min_states, max_actions, min_actions, weights);

[likelihood, Q] = get_likelihood_and_q(as, rs, ss, alpha, exp(beta), gamma, initial_Q);
if isnan(likelihood)
    display('nan');
end
posterior = likelihood + prior([alpha, beta, gamma], weights);


for i = 1:number_of_iterations
    
    %% Sampling
    alpha_prime = 2 * alpha_range_length * step_size * (rand(1) - 0.5) + alpha;
    beta_prime = 2 * beta_range_length * step_size * (rand(1) - 0.5) + beta;
    gamma_prime = 2 * gamma_range_length * step_size * (rand(1) - 0.5) + gamma;
    weight_prime = 2 * weight_range_length * step_size * (rand(1) - 0.5) + weights;
    
    primes = [alpha_prime, beta_prime, gamma_prime, weight_prime];
    
    loop_count = 0;
    % resample if alpha, beta, or gamma fall out of range
    while nnz(primes > lower_bounds) < 4 || nnz(primes < upper_bounds) < 4
        alpha_prime = 2 * alpha_range_length * step_size * (rand(1) - 0.5) + alpha;
        beta_prime = 2 * beta_range_length * step_size * (rand(1) - 0.5) + beta;
        gamma_prime = 2 * gamma_range_length * step_size * (rand(1) - 0.5) + gamma;
        weight_prime = 2 * weight_range_length * step_size * (rand(1) - 0.5) + weights;
        
        primes = [alpha_prime, beta_prime, gamma_prime, weight_prime];
        if loop_count > 500
            display('oops');
            return
        end
    end
    
    %% Accept or Reject
    rs = get_rewards(action_data, state_data, max_states, min_states, max_actions, min_actions, weights);
    [likelihood_prime, Q_prime] = get_likelihood_and_q(as, rs, ss, primes(1), exp(primes(2)),primes(3), initial_Q);
    if isnan(likelihood_prime)
        display('nan');
    end
    posterior_prime = likelihood_prime + prior([alpha_prime, beta_prime, gamma_prime], weight_prime);
    
    if posterior_prime < posterior || rand(1) < exp(posterior - posterior_prime)
        alpha = alpha_prime;
        beta = beta_prime;
        gamma = gamma_prime;
        posterior = posterior_prime;
        weights = weight_prime;
        Q = Q_prime;
    end
    
    history(i,:) = [alpha, beta, gamma, weights];
end

history_means = mean(history);
alpha = history_means(1); beta = history_means(2); gamma = history_means(3); weights = history_means(4);

end

