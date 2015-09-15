clear;
tic

cd ..
cd ..
cd ..

addpath(genpath('whole_body_data'));
addpath(genpath('scripts/whole_body_data/slice_sampler'));

% subjects = 1:13;
subjects = [3,7,8,9,10,13];

number_of_subjects = length(subjects);

histories = cell(number_of_subjects, 1);


% for sub_no = 13:number_of_subjects
parfor (sub_no = subjects, 6)

    [history] = get_metaparameters_of_subject(sub_no);
    histories{sub_no,1} = history;
    
    display(num2str(sub_no));
end

save('./results/whole_body/slice_sampler_with_large_w.mat');

toc
