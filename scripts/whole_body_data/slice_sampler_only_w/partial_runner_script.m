clear;
tic

cd ..
cd ..
cd ..

addpath(genpath('whole_body_data'));
addpath(genpath('scripts/whole_body_data/slice_sampler_only_w'));

subjects = 1:12;
% subjects = [3,7,8,9,10,13];

number_of_subjects = length(subjects);

histories = cell(number_of_subjects, 1);


% for i = subjects
parfor (i = 1:number_of_subjects, 6)
    
    sub_no = subjects(i);
    [history] = get_metaparameters_of_subject(sub_no);
    histories{i,1} = history;
    
    display(num2str(sub_no));
end

save('./results/whole_body/slice_sampler_only_w_10k_trials.mat');

toc