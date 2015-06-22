function [ corrxy ] = autocovariance( x )
%AUTOCOVARIANCE Summary of this function goes here
%   Detailed explanation goes here

y = x;
corrxy = ifft(fft(x) .* conj(fft(y)));
% corrxy = [corrxy(end - length(x) + 2:end); corrxy(1:length(x))];

% covarxy = corrxy * sqrt(varx) * sqrt(vary);

end

