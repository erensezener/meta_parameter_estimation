clear;
tic

cd ..
cd ..
cd ..

addpath(genpath('whole_body_data'));
addpath(genpath('scripts/whole_body_data/multiple_ws'));

number_of_subjects = 13;
number_of_trials = 15;

results = cell(number_of_subjects, number_of_trials);
histories = cell(number_of_subjects, number_of_trials);

% for sub_no = 2:number_of_subjects
parfor (sub_no = 7:number_of_subjects, 6)
    %     try
    
    [result, history] = get_metaparameters_of_subject(sub_no);
    results(sub_no,:) = result';
    histories(sub_no,:) = history';
    
    display(num2str(sub_no));
    
    
    %     catch
    %         results(sub_no,:) = cell(1,number_of_trials);
    %         display('oops in script');
    %     end
end

save('./results/whole_body/with_histories.mat');

toc
