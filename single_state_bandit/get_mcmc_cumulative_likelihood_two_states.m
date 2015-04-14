function [ alpha, beta ] = get_mcmc_cumulative_likelihood_two_states(as, rs)
%GET_MCMC_CUMULATIVE_LIKELIHOOD Summary of this function goes here
%   Detailed explanation goes here

alpha_beta = [0.01, 0.5];
step_radius = 0.01;
initial_Q = [0, 0];
number_of_iterations = 2000;


likelihood = get_action_likelihood(as, rs, alpha_beta(1), alpha_beta(2), initial_Q);

for i = 1:number_of_iterations
    
    %hack to obtain only positive alphas and betas
    [alpha_prime, beta_prime] = circular_uniform(alpha_beta(1), alpha_beta(2), step_radius);
    alpha_beta_prime = [alpha_prime, beta_prime];
    
    while nnz(alpha_beta_prime > [0,0]) < 2 && nnz(alpha_beta_prime < [1,5]) < 2
        alpha_beta_prime = circular_uniform(alpha_beta(1), alpha_beta(2), step_radius);
    end
    alpha_beta_prime = [alpha_prime, beta_prime];
    %end hack

    likelihood_prime = get_action_likelihood(as, rs, alpha_beta_prime(1), alpha_beta_prime(2), initial_Q);
    if likelihood_prime < likelihood || rand(1) < exp(likelihood - likelihood_prime)
        alpha_beta = alpha_beta_prime;
        likelihood = likelihood_prime;
    end
end
    
alpha = alpha_beta(1);
beta = alpha_beta(2);

end

