clear;

cd ..
cd ..

addpath(genpath('whole_body_data'));
addpath(genpath('scripts/whole_body_data'));

number_of_subjects = 13;
number_of_trials = 15;

results = cell(number_of_subjects, number_of_trials);

for sub_no = 1:number_of_subjects
    for series_no = 1:number_of_trials
        [alpha, beta, gamma, weight] = runner_parallel_inner(sub_no, series_no);
        results{sub_no, series_no} = [alpha, beta, gamma, weight];
    end
end

save('./results/whole_body/run1.mat')