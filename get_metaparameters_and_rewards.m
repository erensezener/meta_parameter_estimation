function [ alpha, beta, gamma, weight ] = get_metaparameters_and_rewards(as, ss, raw_states, raw_actions, num_states, num_actions)
%Does MCMC simulation to find the most likely metaparameters

gamma_range = [0.3, 0.99];
alpha_range = [0.001, 0.99];
beta_range = [0.001, 5];
weight_range = [0.01, 100];
step_size = 0.05;
initial_Q = zeros(num_states,num_actions); %rows are states
number_of_iterations = 10000;


%% get range lengths
alpha_range_length = (alpha_range(2) - alpha_range(1));
beta_range_length = (beta_range(2) - beta_range(1));
gamma_range_length = (gamma_range(2) - gamma_range(1));
weight_range_length = (weight_range(2) - weight_range(1));

%% get lower and upper bounds
lower_bounds = [alpha_range(1), beta_range(1), gamma_range(1), weight_range(1)];
upper_bounds = [alpha_range(2), beta_range(2), gamma_range(2), weight_range(2)];

%% get initial values
alpha = alpha_range_length * rand(1) + alpha_range(1);
beta = beta_range_length * rand(1) + beta_range(1);
gamma = gamma_range_length * rand(1) + gamma_range(1);
weight = weight_range_length * rand(1) + weight_range(1);

%% Calculate rewards
rs = get_rewards(raw_actions, raw_states, weight);

%% Calculate likelihood
likelihood = get_likelihood(as, rs, ss, alpha, beta, gamma, initial_Q);

for i = 1:number_of_iterations
    
    %% Sampling
    alpha_prime = 2 * alpha_range_length * step_size * (rand(1) - 0.5) + alpha;
    beta_prime = 2 * beta_range_length * step_size * (rand(1) - 0.5) + beta;
    gamma_prime = 2 * gamma_range_length * step_size * (rand(1) - 0.5) + gamma;
    weight_prime = 2 * weight_range_length * step_size * (rand(1) - 0.5) + weight;
    primes = [alpha_prime, beta_prime, gamma_prime, weight_prime];
    
    % resample if alpha, beta, or gamma fall out of range
    while nnz(primes > lower_bounds) < 4 || nnz(primes < upper_bounds) < 4
        alpha_prime = 2 * alpha_range_length * step_size * (rand(1) - 0.5) + alpha;
        beta_prime = 2 * beta_range_length * step_size * (rand(1) - 0.5) + beta;
        gamma_prime = 2 * gamma_range_length * step_size * (rand(1) - 0.5) + gamma;
        weight_prime = 2 * weight_range_length * step_size * (rand(1) - 0.5) + weight;
        primes = [alpha_prime, beta_prime, gamma_prime, weight_prime];
    end
    
    %% Calculate rewards
    rs = get_rewards(raw_actions, raw_states, weight);
    
    %% Accept or Reject
    likelihood_prime = get_likelihood(as, rs, ss, primes(1), primes(2),primes(3), initial_Q);
    if likelihood_prime < likelihood || rand(1) < exp(likelihood - likelihood_prime)
        alpha = alpha_prime;
        beta = beta_prime;
        gamma = gamma_prime;
        weight = weight_prime;
        likelihood = likelihood_prime;
    end
end
end