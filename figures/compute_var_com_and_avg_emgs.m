cd ..
addpath(genpath('whole_body_data'));

values = cell(13,15);

for subject_no = 1:13
% parfor (subject_no = 2:number_of_subjects, 7)
    for trial_no = 1:15
        data = selection_lean(subject_no, trial_no);
        CoM = data(:,3);
        EMG_data = data(:,[end-1, end]);
        values{subject_no, trial_no} = [var(CoM), mean(EMG_data)];
    end
end

save('./figures/EMG_varCOM_per_subject_and_trial.mat');