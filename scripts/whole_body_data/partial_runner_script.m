clear;

cd ..
cd ..

addpath(genpath('whole_body_data'));
addpath(genpath('scripts/whole_body_data'));

number_of_subjects = 13;
number_of_trials = 15;

results = cell(number_of_subjects, number_of_trials);
% results = zeros(number_of_subjects, number_of_trials);

series_no=1;

parfor sub_no = 2:number_of_subjects
    % for series_no = 4:number_of_trials
    try
        [alpha, beta, gamma, weight] = runner_parallel_inner(sub_no, series_no);
        results{sub_no, series_no} = [alpha, beta, gamma, weight];
    catch
        display(strcat('e',num2str(sub_no), ',', num2str(series_no)))
        results{sub_no, series_no} = [-1, -1, -1, -1];
    end
end


save('./results/whole_body/only_1s.mat');

