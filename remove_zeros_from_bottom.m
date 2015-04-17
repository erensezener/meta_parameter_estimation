function [ data ] = remove_zeros_from_bottom( data )

data( ~any(data,2), : ) = [];

end

