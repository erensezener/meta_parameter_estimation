clear;

cd ..
cd ..
cd ..

addpath(genpath('whole_body_data'));
addpath(genpath('scripts/whole_body_data/cumulative_q'));

number_of_subjects = 13;
number_of_trials = 15;

results = cell(number_of_subjects, number_of_trials);

parfor (sub_no = 2:number_of_subjects, 5)
    temp = get_metaparameters_of_subject(sub_no);
    display(num2str(sub_no));
    results(sub_no,:) = temp';
end

save('./results/whole_body/q_transfer_2.mat');
