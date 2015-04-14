function [ negative_log_likelihood ] = get_likelihood(as, rs, ss, alpha, beta, gamma, initial_Q)
% Calculates the likelihood of a trajectory given the metaparameters

Q = initial_Q;
num_actions = size(Q,2);
negative_log_likelihood = 0;

for i = 1:size(as,1)-1

    %% Find pmf for actions
    unnormalized_p_as = zeros(1,num_actions);
    for j = 1:num_actions
        unnormalized_p_as(1,j) = exp(beta * Q(ss(i,1),j));
    end
    normalized_p_as = unnormalized_p_as / sum(unnormalized_p_as);
    
    %% Calculate the contribution to the NLL
    negative_log_likelihood = negative_log_likelihood - log(normalized_p_as(as(i,1)));

    %% Update the Q function
    TD_error = rs(i,1) + gamma * max(Q(ss(i+1),:)) - Q(ss(i),as(i));
    Q(ss(i),as(i)) = Q(ss(i),as(i)) + alpha * TD_error;
end

end

