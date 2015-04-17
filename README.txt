For a demo,
First run q_learn_two_state.m to run a Q-learning agent in a two-state environment. 
Then run, the meta parameter estimation code as:
[alpha_est,beta_est, gamma_est] = get_metaparameters(as, rs, ss, 2, 2)

Experiments can be run via:
nohup \matlab -nojvm -nodisplay < runner_script.m >& driver.log &
