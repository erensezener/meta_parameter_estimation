function [ states,  borders] = discretize( data, num_states )

quantiles = linspace(0,1,num_states+1);
borders = quantile(data,quantiles);
labels = num2cell(cellfun(@num2str,num2cell(1:num_states)))'; %creates {'1','2',...}
states = zeros(size(data));

if size(data,2) > 1
    for i=1:size(data,2) %loop over the dimensions
        states(:,i) = ordinal(data(:,i),labels,[],borders(:,i))';
    end   
else
    states = ordinal(data,labels,[],borders)';
end

states = int32(states); %ordinals to ints
end

