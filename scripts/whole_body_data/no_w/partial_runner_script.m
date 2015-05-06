clear;

cd ..
cd ..
cd ..

addpath(genpath('whole_body_data'));
addpath(genpath('scripts/whole_body_data/no_w'));

number_of_subjects = 13;
number_of_trials = 15;

results = cell(number_of_subjects, number_of_trials);
% results = zeros(number_of_subjects, number_of_trials);


parfor sub_no = 2:number_of_subjects
    for series_no = 1:number_of_trials
        try
            [alpha, beta, gamma] = runner_parallel_inner(sub_no, series_no);
            results{sub_no, series_no} = [alpha, beta, gamma];
        catch
            display(strcat('e',num2str(sub_no), ',', num2str(series_no)))
            results{sub_no, series_no} = [-1, -1, -1];
        end
    end
end


save('./results/whole_body/all_data.mat');

