%For 2-armed bandit
clear;

action1_reward = [0.7, 5; 0.3 0];
action2_reward = [0.5, 2; 0.5 0];
rewards = {action1_reward, action2_reward};

% gamma = 0.9;
alpha = 0.2;
beta = 2;
Q = [0, 0];

number_of_iterations = 1000;

Qs = zeros(number_of_iterations + 1, size(Q,2));
Qs(1,:) = Q;
as = zeros(number_of_iterations, 1);
rs = zeros(number_of_iterations, 1);


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
    as(i,1) = action;
    % end sampling
    
    
    %sample from reward pmf
    reward_pmf = rewards{action};
    reward = -1;
    cum = 0;
    random_value = rand(1);
    for j = 1:size(reward_pmf,1)
        if random_value < reward_pmf(j,1) + cum
            reward = reward_pmf(j,2);
            break;
        end
        cum = cum + reward_pmf(j,1);
    end
    rs(i,1)=reward;
    % end sampling
    
    TD_error = reward - Q(action);
    Q(action) = Q(action) + alpha * TD_error;
    Qs(i + 1,:) = Q;
    
    
end

%returns Qs, as, ys
plot(Qs)