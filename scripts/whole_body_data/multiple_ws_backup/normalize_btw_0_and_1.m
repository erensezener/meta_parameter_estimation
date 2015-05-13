function [ output_args ] = normalize_btw_0_and_1( input_args )
%NORMALIZE_BTW_0_AND_1 Summary of this function goes here
%   Detailed explanation goes here

output_args = bsxfun(@rdivide, bsxfun(@minus,input_args,min(input_args)), ...
    bsxfun(@minus,max(input_args),min(input_args)));


end

