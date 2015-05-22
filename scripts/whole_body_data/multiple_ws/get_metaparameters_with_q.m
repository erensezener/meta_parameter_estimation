function [ alpha, beta, gamma, Q, weights] = get_metaparameters_with_q(as, ss, initial_Q, state_data, ...
    action_data, max_states, min_states, max_actions, min_actions)
%Does MCMC simulation to find the most likely metaparameters

gamma_range = [0.1, 0.99];
alpha_range = [0.1, 0.99];
beta_range = [-3, 1.5];
weight_range = [0.1, 0.99];
step_size = 0.05;
number_of_iterations = 3000;

% get range lengths
alpha_range_length = (alpha_range(2) - alpha_range(1));
beta_range_length = (beta_range(2) - beta_range(1));
gamma_range_length = (gamma_range(2) - gamma_range(1));
weight_range_length = (weight_range(2) - weight_range(1));

% get lower and upper bounds
lower_bounds = [alpha_range(1), beta_range(1), gamma_range(1), weight_range(1)];
upper_bounds = [alpha_range(2), beta_range(2), gamma_range(2), weight_range(2)];

% get initial values
alpha = alpha_range_length * rand(1) + alpha_range(1);
beta = beta_range_length * rand(1) + beta_range(1);
gamma = gamma_range_length * rand(1) + gamma_range(1);
weights = weight_range_length * rand(1) + weight_range(1);

rs = get_rewards(action_data, state_data, max_states, min_states, max_actions, min_actions, weights);

[likelihood, Q] = get_likelihood_and_q(as, rs, ss, alpha, exp(beta), gamma, initial_Q);
if isnan(likelihood)
    display('nan');
end

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
    
    if likelihood_prime < likelihood || rand(1) < exp(likelihood - likelihood_prime)
        alpha = alpha_prime;
        beta = beta_prime;
        gamma = gamma_prime;
        likelihood = likelihood_prime;
        weights = weight_prime;
        Q = Q_prime;
    end
end

end

