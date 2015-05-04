function [] = scatter_plot_3d( results )
%SCATTER_PLOT_3D Summary of this function goes here
%   Detailed explanation goes here

averages = zeros(12,3);

for i = 1:12
    total = zeros(1,3);
    for j = 1:15
        total = total + results{i+1, j};
    end
    averages(i,:) = total / 15;
end

averages = [averages([1:5],:); averages([7:12],:)];
scatter3(averages(:,1), averages(:,2), averages(:,3));
xlabel('alpha'); ylabel('beta'); zlabel('gamma');

end
