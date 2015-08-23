function [ avgs ] = show_avgs(  results )

avgs = zeros(12, size(results{2,1},2));

for i = 2:13
    t = results{i,1};
    t = t(end/3:end,:); %get rid of the first 1/4th of the data
    avgs(i-1, :) = mean(t);
end

end