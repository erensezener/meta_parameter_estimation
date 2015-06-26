function [] = plot_trials_3d( i, results )
%SCATTER_PLOT_3D Summary of this function goes here
%   Detailed explanation goes here

averages = zeros(15,4);

for j = 1:15
    averages(j,:) = mean(results{i,j});
end


% scatter3(averages(:,1), averages(:,2), averages(:,3));
% xlabel('alpha'); ylabel('beta'); zlabel('gamma');

plot(averages(:,4));
% figure;
% plot(averages(:,[2]));

% plot(averages);


end
