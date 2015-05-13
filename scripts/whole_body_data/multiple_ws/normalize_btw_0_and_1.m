function [ output_args ] = normalize_btw_0_and_1( input_args, max_input, min_input )
%NORMALIZE_BTW_0_AND_1 Summary of this function goes here
%   Detailed explanation goes here

output_args = bsxfun(@rdivide, bsxfun(@minus,input_args,min_input), ...
    bsxfun(@minus,max_input,min_input));


end

