clear;
tic

cd ..
cd ..
cd ..

addpath(genpath('whole_body_data'));
addpath(genpath('scripts/whole_body_data/merged_trials'));

number_of_subjects = 13;

results = cell(number_of_subjects, 1);
histories = cell(number_of_subjects, 1);

% for sub_no = 13:number_of_subjects
parfor (sub_no = 2:number_of_subjects, 6)
    %     try
    
    [result, history] = get_metaparameters_of_subject(sub_no);
    results{sub_no,1} = result';
    histories{sub_no,1} = history';
    
    display(num2str(sub_no));
    
    
    %     catch
    %         results(sub_no,:) = cell(1,number_of_trials);
    %         display('oops in script');
    %     end
end

save('./results/whole_body/merged_trials_3.mat');

toc
