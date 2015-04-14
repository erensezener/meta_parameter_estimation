function [ reduced_states ] = reduce_state_dims( states, number_of_states )
%REDUCE_STATE_DIMS Summary of this function goes here
%   Detailed explanation goes here

[m,n] = size(states);

reduced_states = int32(zeros(m,1));

for i = 1:n
    reduced_states = reduced_states + (number_of_states^(i-1) .* states(:,i)); 
end

end

