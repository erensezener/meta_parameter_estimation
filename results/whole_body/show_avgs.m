function [ avgs ] = show_avgs(  results )

avgs = zeros(13, size(results{2,1},2));

for i = 1:13
    t = results{i,1};
    t = t(end/3:end,:); %get rid of the first 1/4th of the data
    avgs(i, :) = mean(t);
end

end