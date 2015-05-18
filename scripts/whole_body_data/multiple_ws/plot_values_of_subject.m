function [vars ] = plot_values_of_subject( sub_no )
%DISCRETIZE_ALL_TRIALS Summary of this function goes here
%   Detailed explanation goes here

number_of_trials = 15;

vars = zeros(15,1);
emgs = zeros(15,2);

for i = 2:number_of_trials
    data = selection_lean(sub_no,i);
    
    CoM = data(:,3);
    CoM = CoM(CoM < 1000 & CoM > -1000);
    emg = data(1:end,[end-1, end]); %emg data in this case
    vars(i,:) = var(CoM);
    emgs(i,:) = sum(emg);
    
end

figure;
plot(vars);
figure;
plot(emgs);

end

