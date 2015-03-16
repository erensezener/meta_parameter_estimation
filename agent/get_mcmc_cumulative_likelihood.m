function [ alpha, beta, gamma,  Q] = get_mcmc_cumulative_likelihood(as, rs, ss)
%GET_MCMC_CUMULATIVE_LIKELIHOOD Summary of this function goes here
%   Detailed explanation goes here

number_of_state_action_pairs = 4;

gamma_range = [0.5, 0.99];
alpha_range = [0.001, 0.99];
beta_range = [0.001, 5];
Q_range = [-0.005, 8];

number_of_iterations = 50000;
step_size = 0.05;


% get range lengths
alpha_range_length = (alpha_range(2) - alpha_range(1));
beta_range_length = (beta_range(2) - beta_range(1));
gamma_range_length = (gamma_range(2) - gamma_range(1));
Q_range_length = (Q_range(2) - Q_range(1));

% get lower and upper bounds
lower_bounds = [Q_range(1)*ones(1,number_of_state_action_pairs), alpha_range(1), beta_range(1), gamma_range(1)];
upper_bounds = [Q_range(2)*ones(1,number_of_state_action_pairs), alpha_range(2), beta_range(2), gamma_range(2)];

% get initial values
Q = Q_range_length .* rand(1,number_of_state_action_pairs) + Q_range(1)*ones(1,number_of_state_action_pairs);
alpha = alpha_range_length * rand(1) + alpha_range(1);
beta = beta_range_length * rand(1) + beta_range(1);
gamma = gamma_range_length * rand(1) + gamma_range(1);
likelihood = get_action_likelihood_two_states(as, rs, ss, alpha, beta, gamma, reshape(Q,2,2));

for i = 1:number_of_iterations
    
    Q_prime = (2 * Q_range_length * step_size) .* (rand(1,number_of_state_action_pairs) - 0.5) + Q;
    alpha_prime = 2 * alpha_range_length * step_size * (rand(1) - 0.5) + alpha;
    beta_prime = 2 * beta_range_length * step_size * (rand(1) - 0.5) + beta;
    gamma_prime = 2 * gamma_range_length * step_size * (rand(1) - 0.5) + gamma;
    primes = [Q_prime, alpha_prime, beta_prime, gamma_prime];
    
    % resample if alpha, beta, or gamma fall out of range
    while nnz(primes > lower_bounds) < 7 || nnz(primes < upper_bounds) < 7
        Q_prime = (2 * Q_range_length * step_size) .* (rand(1,number_of_state_action_pairs) - 0.5) + Q;
        alpha_prime = 2 * alpha_range_length * step_size * (rand(1) - 0.5) + alpha;
        beta_prime = 2 * beta_range_length * step_size * (rand(1) - 0.5) + beta;
        gamma_prime = 2 * gamma_range_length * step_size * (rand(1) - 0.5) + gamma;
        primes = [Q_prime, alpha_prime, beta_prime, gamma_prime];
    end
        
    likelihood_prime = get_action_likelihood_two_states(as, rs, ss, alpha_prime, beta_prime, gamma_prime, reshape(Q_prime,2,2));
    if likelihood_prime < likelihood || rand(1) < exp(likelihood - likelihood_prime)
        Q = Q_prime;
        alpha = alpha_prime;
        beta = beta_prime;
        gamma = gamma_prime;
        likelihood = likelihood_prime;
    end
end

end

