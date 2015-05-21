function [ means,  stdevs] = plot_trial_averages( results )
%PLOT_TRIAL_AVERAGES Summary of this function goes here
%   Detailed explanation goes here

num_subjects = 6;
num_trials = 15;
num_variables = size(results{2,2},2);

means = zeros(num_trials,num_variables);
stdevs = zeros(num_trials,num_variables);

for i = 1:num_trials
    temp = zeros(num_subjects,num_variables);
    for j = 1:num_subjects
        temp(j,:) = results{j,i};
    end
    means(i,:) = mean(exp(temp));
    stdevs(i,:) = std(exp(temp)) / sqrt(num_subjects);
end

figure;
plotMeanStd([1:1:num_trials],means(:,4)',stdevs(:,4)',stdevs(:,4)',[0.7 0.7 0.9],0);
figure;
plotMeanStd([1:1:num_trials],means(:,5)',stdevs(:,5)',stdevs(:,5)',[0.7 0.9 0.7],0);
figure;
plotMeanStd([1:1:num_trials],means(:,6)',stdevs(:,6)',stdevs(:,6)',[0.9 0.7 0.7],0);


end

