function [ alpha, beta, gamma, a, b, history] = get_metaparameters_with_q(as, ss, initial_Q, ...
    state_data, action_data, max_states, min_states, max_actions, min_actions)
%Does MCMC simulation to find the most likely metaparameters

gamma_range = [0.1, 0.999];
alpha_range = [0.1, 0.999];
beta_range = [-3, 1.5];
a_range = [-1, 1];
b_range = [0, 1];
a_plus_b_range = [0.01, 0.99];

number_of_iterations = 20000;
prior = @(metaparameters, weights) 1;
step_size = 0.1;

history = zeros(number_of_iterations, 5);

% get range lengths
alpha_range_length = (alpha_range(2) - alpha_range(1));
beta_range_length = (beta_range(2) - beta_range(1));
gamma_range_length = (gamma_range(2) - gamma_range(1));
a_range_length = (a_range(2) - a_range(1));
b_range_length = (b_range(2) - b_range(1));


% get lower and upper bounds
lower_bounds = [alpha_range(1), beta_range(1), gamma_range(1), a_range(1), b_range(1), a_plus_b_range(1)];
upper_bounds = [alpha_range(2), beta_range(2), gamma_range(2), a_range(2), b_range(2), a_plus_b_range(2)];

% get initial values
alpha = alpha_range_length * rand(1) + alpha_range(1);
beta = beta_range_length * rand(1) + beta_range(1);
gamma = gamma_range_length * rand(1) + gamma_range(1);
% a = a_range_length * rand(1) + a_range(1);
% b = b_range_length * rand(1) + b_range(1);
a = 0;
b = 0.5;

weights = [a, b];
rs = get_rewards(action_data, state_data, max_states, min_states, max_actions, min_actions, weights);

[likelihood, ~] = get_likelihood_and_q(as, rs, ss, alpha, exp(beta), gamma, initial_Q);
if isnan(likelihood)
    display('nan');
end
posterior = likelihood + prior([alpha, beta, gamma], weights);


for i = 1:number_of_iterations
    
    %% Sampling
    alpha_prime = 2 * alpha_range_length * step_size * (rand(1) - 0.5) + alpha;
    beta_prime = 2 * beta_range_length * step_size * (rand(1) - 0.5) + beta;
    gamma_prime = 2 * gamma_range_length * step_size * (rand(1) - 0.5) + gamma;
    a_prime = 2 * a_range_length * step_size * (rand(1) - 0.5) + a;
    b_prime = 2 * b_range_length * step_size * (rand(1) - 0.5) + b;
    
    primes = [alpha_prime, beta_prime, gamma_prime, a_prime, b_prime, a_prime + b_prime];
    
    loop_count = 0;
    % resample if alpha, beta, or gamma fall out of range
    while nnz(primes > lower_bounds) < size(primes,2) || nnz(primes < upper_bounds) < size(primes,2)
        alpha_prime = 2 * alpha_range_length * step_size * (rand(1) - 0.5) + alpha;
        beta_prime = 2 * beta_range_length * step_size * (rand(1) - 0.5) + beta;
        gamma_prime = 2 * gamma_range_length * step_size * (rand(1) - 0.5) + gamma;
        a_prime = 2 * a_range_length * step_size * (rand(1) - 0.5) + a;
        b_prime = 2 * b_range_length * step_size * (rand(1) - 0.5) + b;
        
        primes = [alpha_prime, beta_prime, gamma_prime, a_prime, b_prime, a_prime + b_prime];
        
        if loop_count > 500
            display('oops');
            return
        end
        loop_count = loop_count + 1;
    end
    
    %% Accept or Reject
    rs = get_rewards(action_data, state_data, max_states, min_states, max_actions, min_actions, weights);
    [likelihood_prime, ~] = get_likelihood_and_q(as, rs, ss, primes(1), exp(primes(2)),primes(3), initial_Q);
    if isnan(likelihood_prime)
        display('nan');
    end
    posterior_prime = likelihood_prime + prior([alpha_prime, beta_prime, gamma_prime], [a, b]);
    
    if posterior_prime < posterior || rand(1) < exp(posterior - posterior_prime)
        alpha = alpha_prime;
        beta = beta_prime;
        gamma = gamma_prime;
        posterior = posterior_prime;
        a = a_prime;
        b = b_prime;
    end
    
    history(i,:) = [alpha, beta, gamma, a, b];
end

history_means = mean(history);
alpha = history_means(1); beta = history_means(2); gamma = history_means(3); a = history_means(4);  b = history_means(5);

end