function [] = runner_parallel_inner( filename_of_data )
%RUNNER_PARALLEL_INNER Summary of this function goes here
%   Detailed explanation goes here

load(strcat('./data/', filename_of_data));
data = ResParsOfExp.Exp.DATA_cartpole;

[ states, actions, rewards ] = get_ras( data );
number_of_states = 8*9^3 + 8 * 9^2 + 8* 9^1 + 8 * 9^0; %a temporary hack
number_of_actions = 4;
[ alpha, beta, gamma ] = get_metaparameters(actions', rewards, states, ...
    number_of_states, number_of_actions);
save(strcat('./results/run3/', filename_of_data));

end

