function [ likelihood ] = get_action_likelihood(as, rs, alpha, beta, initial_Q)
%GET_ACTION_LIKELIHOOD For single state only

%For 2-armed bandit

% action1_reward = [0.9, 1; 0.1 0];
% action2_reward = [0.8, 1; 0.2 0];
% rewards = {action1_reward, action2_reward};

Q = initial_Q;

likelihood = 0;


for i = 1:size(as,1)
    unnormalized_p_as = [exp(beta * Q(1)), exp(beta * Q(2))];
    normalized_p_as = [exp(beta * Q(1)), exp(beta * Q(2))] / sum(unnormalized_p_as);
    
    likelihood = likelihood - log(normalized_p_as(as(i,1)));

    TD_error = rs(i,1) - Q(as(i,1));
    Q(as(i,1)) = Q(as(i,1)) + alpha * TD_error;
end


end

