%For 2-armed bandit
clear;

action1_reward = [0.9, 1; 0.1 0];
action2_reward = [0.8, 0; 0.2 0];
rewards = {action1_reward, action2_reward};

% gamma = 0.9;
alpha = 0.01;
beta = 0.5;
Q = [0, 0];

number_of_iterations = 10000;

Qs = zeros(number_of_iterations + 1, size(Q,2));
Qs(1,:) = Q;

for i = 1:number_of_iterations
    unnormalized_p_as = [exp(beta * Q(1)), exp(beta * Q(2))];
    normalized_p_as = [exp(beta * Q(1)), exp(beta * Q(2))] / sum(unnormalized_p_as);
    
    %sample from action pmf
    action = -1;
    random_value = rand(1);
    cum = 0;
    for j = 1:size(normalized_p_as,2)
        if random_value < normalized_p_as(j) + cum
            action = j;
            break;
        end
        cum = cum + normalized_p_as(j);
    end
    % end sampling
    
    
    %sample from reward pmf
    reward_pmf = rewards{action};
    reward = -1;
    for j = 1:size(reward_pmf,1)
        random_value = rand(1);
        if random_value < reward_pmf(j,1)
            reward = reward_pmf(j,2);
        end
    end
    % end sampling
    
    TD_error = reward - Q(action);
    Q(action) = Q(action) + alpha * TD_error;
    Qs(i + 1,:) = Q;
    
    
end


plot(Qs)