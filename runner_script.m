clear;
load('./data/Negin_SimMain_16_Dec_2014_14_2.mat');
data = ResParsOfExp.Exp.DATA_cartpole;

[ states, actions, rewards ] = get_ras( data );
number_of_states = 8*9^3 + 8 * 9^2 + 8* 9^1 + 8 * 9^0; %temporary hack
number_of_actions = 4;
[ alpha, beta, gamma ] = get_metaparameters(actions', rewards, states, ...
                                                number_of_states, number_of_actions);
                                            
                                          