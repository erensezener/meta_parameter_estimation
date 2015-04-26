clear;
datasets = {'Awais_SimMain_15_Dec_2014_17_19.mat', 'Erhan_SimMain_15_Dec_2014_17_33.mat', ...
    'MazNoisy_SimMain_15_Dec_2014_17_24.mat', 'MAZNormal_SimMain_15_Dec_2014_17_14.mat', ...
    'Negin_SimMain_15_Dec_2014_17_29.mat', 'Negin_SimMain_16_Dec_2014_14_2.mat'};

parfor i = 1:length(datasets)
    runner_parallel_inner(datasets{i});
end