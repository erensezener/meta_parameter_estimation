clear;

cd ..
cd ..
cd ..

addpath(genpath('whole_body_data'));
addpath(genpath('scripts/whole_body_data'));

number_of_subjects = 13;
number_of_trials = 15;

results = cell(number_of_subjects, number_of_trials);
% results = zeros(number_of_subjects, number_of_trials);

sub_no=2;

% parfor sub_no = 2:number_of_subjects
parfor series_no = 1:8
    try
        [alpha, beta, gamma] = runner_parallel_inner(sub_no, series_no);
        results{sub_no, series_no} = [alpha, beta, gamma];
    catch
        display(strcat('e',num2str(sub_no), ',', num2str(series_no)))
        results{sub_no, series_no} = [-1, -1, -1];
    end
end


save('./results/whole_body/sub1_first_half.mat');

