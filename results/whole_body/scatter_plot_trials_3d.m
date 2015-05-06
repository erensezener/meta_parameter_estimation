function [] = scatter_plot_trials_3d( results )
%SCATTER_PLOT_3D Summary of this function goes here
%   Detailed explanation goes here

averages = zeros(15,3);

for j = 1:15
    total = zeros(1,3);
    for i = 1:12
        total = total + results{i+1, j};
    end
    averages(j,:) = total / 12;
end

% averages = [averages([1:5],:); averages([7:12],:)];
% scatter3(averages(:,1), averages(:,2), averages(:,3));
% xlabel('alpha'); ylabel('beta'); zlabel('gamma');
plot(averages)

end
