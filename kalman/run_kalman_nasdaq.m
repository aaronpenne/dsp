clear all; close all;
fig = 0;  % Counter for labeling figures

% Loads entire dataset and sorts it with oldest data at top
load('nas.mat');
nas = flipud(nas);

% Splits the dataset into old and new samples
start = 252;
nas_old = nas(1:start);
nas_new = nas(start+1:end);

% Calculates moving average as the trend to compare
ma(1:2,1) = nas_old(1:2);
for i = 3:length(nas_old)
   ma(i,1) = (nas_old(i) + nas_old(i-1))/2;
end

% Setup model parameters
delta = nas_old - ma;
Z = nas_new';
kf = struct;
kf.A = 6;
kf.B = 0;
kf.H = 1.1667;
kf.P = cov(nas_old);
kf.Q = 0;
kf.R = cov(delta);
kf.x = ma(1);
kf.z = Z(:,1);
kf.u = 0;

% Call kalman filter and iterate steps
F = size(Z);
for i = 1:F(2)-1
    kf(i+1) = call_kalman_func(kf(i));
    z = Z(:,i+1);
    kf(i+1).z = z;
end

for i = 1:F(2)
    kf_nas(i) = kf(i).x(1);    
end

% Account for initialization
kf_nas(1:3) = nas_new(1:3);

% Plot everything
samples_new = [1+start:2*start];
figure; hold on;
plot(nas, 'b-');
plot(samples_new, kf_nas,  'r-');
plot([start start], ylim, 'k--');
xlabel('Samples'); ylabel('Closing Price ($)');
axis([240 300 2600 2900]);
legend('Actual', 'Kalman');
title('Fig 1 - Kalman Filter');

% Calculate MSE and NMSE
sum_mse  = 0;
sum_nmse = 0;
avg_kf = mean(kf_nas);
avg_nas = mean(nas_new);
for i = 1:length(nas_new)
    sum_mse  = sum_mse  + (kf_nas(i)-nas_new(i))^2;
    sum_nmse = sum_nmse + (((kf_nas(i)-nas_new(i))^2)) / (avg_kf * avg_nas);
end
mse  = sum_mse  / length(nas_new);
nmse = sum_nmse / length(nas_new);
disp(mse);
disp(nmse);
