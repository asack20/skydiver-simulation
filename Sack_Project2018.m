% Andrew Sack
% ES 55 
% Final Project
% 12/20/18
clear all; close all; clc;

%% User Input
prompt = {'Starting Height (meters) - max 85000','Skydiver Mass (kg)',...
    'Skydiver Drag Coefficient','Skydiver Cross Sectional Area (square meters)', ...
    'Parachute Drag Coefficient','Parachute Cross Sectional Area (square meters)', ...
    'Parachute Deploy Altitude (meters)'};
title1 = 'Parameters';
dims = [1 50];
definput = {'85000','90', '1', '0.7', '0.75', '20', '1500'};

isValid = false; 
while ~isValid % Loop to reprompt if input is invalid

    answer = inputdlg(prompt,title1,dims,definput);

    height = str2num(answer{1});
    mass = str2num(answer{2});
    Cd_man = str2num(answer{3});
    area_man = str2num(answer{4});
    Cd_par = str2num(answer{5});
    area_par = str2num(answer{6});
    h_deploy = str2num(answer{7});
    
    isValid = validate_input(height, mass, Cd_man, area_man, Cd_par, ...
        area_par, h_deploy);
    if ~isValid
        errordlg('Inputs are not Valid')
    end
end

% global so file input isn't repeated every time airdensity_for_altitude is called
global M; 
M = csvread('density_table.csv'); % Read in air density values

%% Calculations
% Pre Parachute 
tspan_1 = [0 inf];
init_1 = [height 0];
parDeployFcn = @(T, Y) heightevent(T, Y, h_deploy);
opts=odeset('Events', parDeployFcn);

[t1, y1, te1, ye1] = ode45(@(t, y) skydiving_diffeq(t, y, Cd_man, area_man, mass), tspan_1, init_1, opts);

% After Parachute is deployed
tspan_2 = [t1(end) inf];
init_2 = [h_deploy y1(end)];
landFcn = @(T, Y) heightevent(T, Y, 0);
opts=odeset('Events', landFcn);

[t2, y2, te2, ye2] = ode45(@(t, y) skydiving_diffeq(t, y, Cd_par, area_par, mass), tspan_2, init_2, opts);

% Merge pre and post parachute together
t = [t1; t2(2:end)];
pos = [y1(:,1); y2(2:end,1)];
vel = [y1(:,2); y2(2:end,2)];
acc1 = skydiving_accel(y1(:,1),y1(:,2), Cd_man, area_man, mass);
acc2 = skydiving_accel(y2(:,1),y2(:,2), Cd_par, area_par, mass);
acc = [acc1; acc2(2:end)];

% calculate jerk
for n = 1:length(t)-1
    dt(n) = t(n+1) - t(n);
end
jerk = diff(acc) .* dt';

%% Animation
% Interpolate everything so time step is constant
time_step = 5;
t_interp = 0:time_step:te2;

p_interp = interp1(t, pos, t_interp);
v_interp = interp1(t, vel, t_interp);
a_interp = interp1(t, acc, t_interp);
j_interp = interp1(t(1:end-1), jerk, t_interp);

f = figure;
hold on;
ylim([-1000, height])
xlim([-1 1])
axis manual
rectangle('Position', [-1 -1000 2, 1000],'FaceColor', 'g')% 'land'

% Animation loop
for n = 1:length(t_interp)
    title(sprintf('Time: %0.0f Seconds', t_interp(n)));
    
    str = {sprintf('Altitude: %0.0f m', p_interp(n)), ...
        sprintf('Velocity: %0.1f m/s', v_interp(n)), ...
        sprintf('Acceleration: %0.3f m/s^2', a_interp(n)), ...
        sprintf('Jerk: %0.3f m/s^3', j_interp(n))};
    t_handle = text(0.32,0.87*height,str);
    
    if t_interp(n) < te1 % Plot circle for pre parachute
        h = plot(0, p_interp(n), 'or', 'MarkerFaceColor',[1,0,0],'MarkerSize',5);
    else % Plot upside down triangle to represent parachute
        h = plot(0, p_interp(n), 'vb', 'MarkerFaceColor',[0,0,1],'MarkerSize',10);
    end
   
    pause(0.1);
    delete(t_handle);
    delete(h)
    
end 
hold off;
delete(f)

%% Plotting
figure;
subplot(2, 2, 1)
plot(t,pos)
title('Altitude vs Time')
xlabel('Time (seconds)')
ylabel('Altitude (meters)')
xlim([0 te2]);

subplot(2, 2, 2)
plot(t, vel)
title('Velocity vs Time')
xlabel('Time (seconds)')
ylabel('Velocity (m/s)')
xlim([0 te2]);

subplot(2, 2, 3)
plot(t, acc)
title('Acceleration vs Time')
xlabel('Time (seconds)')
ylabel('Acceleration (m/s^2)')
xlim([0 te2]);

subplot(2, 2, 4)
plot(t(1:length(t)-1), jerk)
title('Jerk vs Time')
xlabel('Time (seconds)')
ylabel('Jerk (m/s^3)')
xlim([0 te2]);

figure;
plot(pos, vel)
title('Velocity vs Altitude')
xlabel('Altitude (meters)')
ylabel('Velocity (m/s)')
xlim([0 height]);
set(gca, 'XDir','reverse')