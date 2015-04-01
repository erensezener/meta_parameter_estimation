%This is the code of a Q-learning agent.
%The environment here is composed of two states.
%The agent has two actions: go left OR go right
% State transition rules are give below
% in (current_state, current_action -> next_state, reward) format
% state1, action1 -> state1, sample from reward_pmf_no1 
% state1, action2 -> state2, 0
% state2, action1 -> state1, 0
% state2, action2 -> state1, sample from reward_pmf_no2 

clear;

%% Rewards
reward_pmf_no1 = [0.3, 9; 0.7 0]; % [(probability, reward)]
reward_pmf_no2 = [0.6, 6; 0.4 0]; % [(probability, reward)]
rewards = {reward_pmf_no1, reward_pmf_no2};

%% Agent parameters
gamma = 0.90;
alpha = 0.15;
beta = 0.12;
Q = [0, 0, 0, 0]; %state x action
state = 2; %initial state
next_state = -1;

number_of_iterations = 4000;

%% Initializations
Qs = zeros(number_of_iterations + 1, size(Q,2));
Qs(1,:) = Q;
as = zeros(number_of_iterations, 1);
rs = zeros(number_of_iterations, 1);
ss = zeros(number_of_iterations+1, 1);
ss(1,1) = state;

%% The loop
for i = 1:number_of_iterations
    Q = reshape(Q, 2, 2)';
    unnormalized_p_as = [exp(beta * Q(state,1)), exp(beta * Q(state,2))];
    normalized_p_as = unnormalized_p_as / sum(unnormalized_p_as);
    
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
    
    reward = 0;

    %state change
    if state == 1 && action == 1
        next_state = 1;
        %sample from reward pmf
        reward_pmf = rewards{1};
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
    elseif state == 1 && action == 2
        next_state = 2;
    elseif state == 2 && action == 1
        next_state = 1;
    elseif state == 2 && action == 2
        next_state = 2;
        %sample from reward pmf
        reward_pmf = rewards{2};
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
    end
    %
    
    TD_error = reward + gamma * max(Q(next_state,:)) - Q(state,action);
    Q(state,action) = Q(state,action) + alpha * TD_error;
    state = next_state;
    Q = reshape(Q', 1, 4);
    Qs(i + 1,:) = Q;
    ss(i+1,1) = state;
end

plot(Qs)