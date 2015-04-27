clear;

cd ..
cd ..

addpath(genpath('whole_body_data'));
addpath(genpath('scripts/whole_body_data'));


for sub_no = 1:13
    for series_no = 1:15
        runner_parallel_inner(sub_no, series_no);
    end
end