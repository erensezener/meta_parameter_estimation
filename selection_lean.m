%%% SELECTION FUNCTION
% for CoDyCo EXP2 measurement data

% the function takes 3 paraeters:
%subject number
%measurement series number
%handle (0=no,1=yes)

% and returns a matrix:
%time
%reference perturbation force in world X axis
%measured perturbation force in world X axis
%COP in x axis (anteroposterior) in world frame
%COP in y axis (perpendicular to x) in world frame
%COM in x
%COM in y
%COM in z
%handle force [x, y, z] in world frame
%EMG measurements (TA and GA muscles)

%world frame: X point in front of subject, Y in left of subject and Z points upwards

% Luka Peternel
% Eren Sezener

function output = selection_lean(sub_nr, series_nr)

% load mat file
eval(['load sub' num2str(sub_nr) '.mat;']);

% with (1) or without (0) hadnle?
eval(['tmp = data.nohandle.serija_' num2str(series_nr) ';']);


% time
time = data.pert(:,1);
f1 = zeros(length(tmp.sensor),1);
f2 = zeros(length(tmp.sensor),1);

for i=1:length(tmp.sensor)
    f1(i,1) = sqrt(tmp.sensor(i,1)^2+tmp.sensor(i,2)^2+tmp.sensor(i,3)^2); % front sensor
    f2(i,1) = sqrt(tmp.sensor(i,9)^2+tmp.sensor(i,10)^2+tmp.sensor(i,11)^2); % back sesnor
end

% perturbation force (in world frame X axis)
pert_force(:,1) = f1(:,1)-f2(:,1);


difference = length(time) - size(tmp.EMG,1);

% EMG (TA and GA muscles)
if difference < 0
    EMG = tmp.EMG(1:length(time),:);
else
    EMG = tmp.EMG;
end

% load mat file for optotrack
eval(['load kinsub' num2str(sub_nr) '.mat;']);

eval(['tmp = data.nohandle.serija_' num2str(series_nr) ';']);


% OPTO data: 1, 2, 3, 4, 5, 6, 7, 8, 9..... foot, ankle, knee, hip, should, lowback, hiback, fp, fs
COMx = tmp.optotack(:,6*3-2) - tmp.optotack(:,2*3-2); % COM x in mm

% output matrix

if difference < 0
    output = [time, pert_force, COMx, EMG];
else 
    output_wo_EMG =[time, pert_force, COMx];
    output_wo_EMG = output_wo_EMG(1:end-difference,:);
    output = [output_wo_EMG, EMG];
end

end