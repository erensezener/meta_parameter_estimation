function [] = create_dim_hist( results, dim )
% Creates a hist of a dim

vals = zeros(12,1);
for i = 2:13
    t = results{i,1};
    t = t(end/5:end,dim); %get rid of the first 1/5th of the data
    vals(i-1,1) = mean(t);
end

hist(vals);
mean(vals)

end