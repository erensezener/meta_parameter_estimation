function [ means,  stdevs] = plot_trial_averages( results )
%PLOT_TRIAL_AVERAGES Summary of this function goes here
%   Detailed explanation goes here

set(0,'DefaultFigureRenderer','opengl');

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
    means(i,:) = mean([temp(:,[1,3]), exp(temp(:,2))]);
    stdevs(i,:) = std([temp(:,[1,3]), exp(temp(:,2))]) / sqrt(num_subjects);
end

figure;
hold on;
plot(means(:,1),'b-');
plotMeanStd([1:1:num_trials],means(:,1)',stdevs(:,1)',stdevs(:,1)',[0.7 0.7 0.9],0);
% figure;
plot(means(:,2),'r:');
plotMeanStd([1:1:num_trials],means(:,2)',stdevs(:,2)',stdevs(:,2)',[0.9 0.7 0.7],0);
legend('alpha mean', 'alpha SEM', 'gamma mean', 'gamma SEM');
xlabel('Trial number')
ylabel('Values')
set(gca, 'LineWidth', 1.2)
box on


figure;
hold on;
plot(means(:,3),'b-');
plotMeanStd([1:1:num_trials],means(:,3)',stdevs(:,3)',stdevs(:,3)',[0.7 0.7 0.9],0);
legend('beta mean', 'beta SEM');
xlabel('Trial number')
ylabel('Values')
set(gca, 'LineWidth', 1.2)
box on

end

