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

function output = selection(sub_nr, series_nr, handle)

% load mat file
eval(['load sub' num2str(sub_nr) '.mat;']);

% with (1) or without (0) hadnle?
if(handle == 1)
    eval(['tmp = data.handle.serija_' num2str(series_nr) ';']);
else
    eval(['tmp = data.nohandle.serija_' num2str(series_nr) ';']);
end

% time
time = data.pert(:,1);

% refernce pert force
pert_force(:,1) = data.pert(:,2);

% force sensors
rotmat = single(rotz(pi/4)); % rotation matrix to transform handle sensor to world frame

for i=1:length(tmp.sensor)
    f1(i,1) = sqrt(tmp.sensor(i,1)^2+tmp.sensor(i,2)^2+tmp.sensor(i,3)^2); % front sensor
    f2(i,1) = sqrt(tmp.sensor(i,9)^2+tmp.sensor(i,10)^2+tmp.sensor(i,11)^2); % back sesnor
    if(handle == 1)
        %handle_force_abs(i,1) = sqrt(tmp.sensor(i,17)^2+tmp.sensor(i,18)^2+tmp.sensor(i,19)^2);
        handle_sensor_rotated(i,1:3) = (rotmat(1:3,1:3)*[tmp.sensor(i,17) tmp.sensor(i,18) tmp.sensor(i,19)]')';
        handle_sensor_rotated(i,4:6) = (rotmat(1:3,1:3)*[tmp.sensor(i,20) tmp.sensor(i,21) tmp.sensor(i,22)]')';
    else
        %handle_force_abs(i,1) = 0;
        handle_sensor_rotated(i,:) = [0 0 0 0 0 0];
    end
end

% perturbation force (in world frame X axis)
pert_force(:,2) = f1(:,1)-f2(:,1);

% handle force (force + torque contributions)
lever = single(0.174);
for j=1:length(handle_sensor_rotated)
    handle_force(j,1) = handle_sensor_rotated(j,1)-handle_sensor_rotated(j,5)/lever;
    handle_force(j,2) = -handle_sensor_rotated(j,2)+handle_sensor_rotated(j,4)/lever;
    handle_force(j,3) = handle_sensor_rotated(j,3);
end

difference = length(time) - size(tmp.EMG,1);

% EMG (TA and GA muscles)
if difference < 0
    EMG = tmp.EMG(1:length(time),:);
else
    EMG = tmp.EMG;
end

% COP
COPx = tmp.forceplate(:,7); % in mm
COPy = -tmp.forceplate(:,8); % multiplied by -1 to transform to world frame

% load mat file for optotrack
eval(['load kinsub' num2str(sub_nr) '.mat;']);

% with (1) or without (0) hadnle?
if(handle == 1)
    eval(['tmp = data.handle.serija_' num2str(series_nr) ';']);
else
    eval(['tmp = data.nohandle.serija_' num2str(series_nr) ';']);
end

% OPTO data: 1, 2, 3, 4, 5, 6, 7, 8, 9..... foot, ankle, knee, hip, should, lowback, hiback, fp, fs
COMx = tmp.optotack(:,6*3-2) - tmp.optotack(:,2*3-2); % COM x in mm
COMy = tmp.optotack(:,6*3-1) - tmp.optotack(:,2*3-1); % COM y
COMz = tmp.optotack(:,6*3) - tmp.optotack(:,2*3); % COM z

% output matrix

if difference < 0
    output = [time, pert_force, COPx, COPy, COMx, COMy, COMz, handle_force, EMG];
else 
    output_wo_EMG =[time, pert_force, COPx, COPy, COMx, COMy, COMz, handle_force];
    output_wo_EMG = output_wo_EMG(1:end-difference,:);
    output = [output_wo_EMG, EMG];
end

end