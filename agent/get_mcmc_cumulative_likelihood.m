function [ alpha, beta, gamma ] = get_mcmc_cumulative_likelihood(as, rs, ss)
%GET_MCMC_CUMULATIVE_LIKELIHOOD Summary of this function goes here
%   Detailed explanation goes here

gamma_range = [0.5, 0.99];
alpha_range = [0.001, 0.99];
beta_range = [0.001, 5];
step_size = 0.05;
initial_Q = [0, 0; 0, 0];
number_of_iterations = 5000;

% get range lengths
alpha_range_length = (alpha_range(2) - alpha_range(1));
beta_range_length = (beta_range(2) - beta_range(1));
gamma_range_length = (gamma_range(2) - gamma_range(1));

% get lower and upper bounds
lower_bounds = [alpha_range(1), beta_range(1), gamma_range(1)];
upper_bounds = [alpha_range(2), beta_range(2), gamma_range(2)];

% get initial values
alpha = alpha_range_length * rand(1) + alpha_range(1);
beta = beta_range_length * rand(1) + beta_range(1);
gamma = gamma_range_length * rand(1) + gamma_range(1);
likelihood = get_action_likelihood_two_states(as, rs, ss, alpha, beta, gamma, initial_Q);

for i = 1:number_of_iterations
    
    alpha_prime = 2 * alpha_range_length * step_size * (rand(1) - 0.5) + alpha;
    beta_prime = 2 * beta_range_length * step_size * (rand(1) - 0.5) + beta;
    gamma_prime = 2 * gamma_range_length * step_size * (rand(1) - 0.5) + gamma;
    primes = [alpha_prime, beta_prime, gamma_prime];
    
    % resample if alpha, beta, or gamma fall out of range
    while nnz(primes > lower_bounds) < 3 || nnz(primes < upper_bounds) < 3
        alpha_prime = 2 * alpha_range_length * step_size * (rand(1) - 0.5) + alpha;
        beta_prime = 2 * beta_range_length * step_size * (rand(1) - 0.5) + beta;
        gamma_prime = 2 * gamma_range_length * step_size * (rand(1) - 0.5) + gamma;
        primes = [alpha_prime, beta_prime, gamma_prime];
    end
        
    likelihood_prime = get_action_likelihood_two_states(as, rs, ss, primes(1), primes(2),primes(3), initial_Q);
    if likelihood_prime < likelihood || rand(1) < exp(likelihood - likelihood_prime)
        alpha = alpha_prime;
        beta = beta_prime;
        gamma = gamma_prime;
        likelihood = likelihood_prime;
    end
end

end

