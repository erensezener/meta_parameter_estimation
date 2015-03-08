len = 100;
errors = zeros(len,len);
slice_a = linspace(0.001,1,len);
slice_b = linspace(1,6,len);

i = 0; 
for a=slice_a
    i = i + 1;
    j = 0;
    for b=slice_b
        j = j + 1;
    errors(i,j) = get_action_likelihood(as, rs, a, b, [0, 0]);
    end
end

h = pcolor(slice_b, slice_a, -errors);

[v,ind]=max(-errors);
[v1,ind1]=max(max(-errors));

display(strcat('alpha is ', num2str(slice_a(ind(ind1)))))
display(strcat('beta is ', num2str(slice_b(ind1))))

hold on;
scatter(slice_b(ind1),slice_a(ind(ind1)),'k');