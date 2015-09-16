clear;
tic

cd ..
cd ..
cd ..

addpath(genpath('whole_body_data'));
addpath(genpath('scripts/whole_body_data/slice_sampler_debug'));

% subjects = 1:13;
% subjects = [3,7,8,9,10,13];
sub_no = 10;
widths = logspace(-1,1,6);

histories = cell(length(widths), 1);

% for sub_no = 13:number_of_subjects
parfor (i = 1:length(widths), 6)
    try
        [history] = get_metaparameters_of_subject(sub_no, widths(i));
        histories{i,1} = history;
    catch
        histories{i,1} = -1;
        display(strcat('oops in ', int2str(i)));
    end
    
    display(num2str(sub_no));
end

save('./results/whole_body/slice_sampler_debug_with_large_w.mat');

toc
