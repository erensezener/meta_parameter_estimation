function [] = plot_trials_of_single_subject( i, results )
%SCATTER_PLOT_3D Summary of this function goes here
%   Detailed explanation goes here

dim = size(results{2,1},2);

averages = zeros(15,dim);

for j = 1:15
    t = results{i,j};
    averages(j,:) = mean(t(end/4:end,:));
end


% scatter3(averages(:,1), averages(:,2), averages(:,3));
% xlabel('alpha'); ylabel('beta'); zlabel('gamma');

plot(averages(:,dim));
% figure;
% plot(averages(:,[2]));

% plot(averages);


end
