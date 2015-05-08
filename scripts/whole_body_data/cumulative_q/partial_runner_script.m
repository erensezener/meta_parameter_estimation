clear;

cd ..
cd ..
cd ..

addpath(genpath('whole_body_data'));
addpath(genpath('scripts/whole_body_data/cumulative_q'));

number_of_subjects = 7;
number_of_trials = 15;

results = cell(number_of_subjects, number_of_trials);

%for sub_no = 2:number_of_subjects
parfor (sub_no = 2:number_of_subjects, 6)
    display(num2str(sub_no));
    try
      results(sub_no,:) = get_metaparameters_of_subject(sub_no)';
    catch
      results(sub_no,:) = cell(1,number_of_trials);
      display('oops in script');
    end
end

save('./results/whole_body/subsample_by_4.mat');
