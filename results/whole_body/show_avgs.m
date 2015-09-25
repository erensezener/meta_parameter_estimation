function [ avgs ] = show_avgs(  results )

length = size(results,1);

avgs = zeros(length, size(results{2,1},2));

for i = 1:length
    t = results{i,1};
    t = t(end/3:end,:); %get rid of the first 1/4th of the data
    avgs(i, :) = mean(t);
end

end