clear all; close all; clc;

ENR_fx = 10;
ENR = 1:100;
PF_set = [10^-1, 10^-2, 10^-3];
nu = 2;
ep = exp(-10);
fig = 0;

% Clairvoyant NP detector
i = 1;
plot_title(i) = {'Clairvoyant'};
PF(i,:) = 0.01:0.01:1;
PD(i,4,:) = Q(Qinv(PF(i,:))-sqrt(ENR_fx));
for j = 1:3
    for k = 1:length(ENR)
        PD(i,j,k) = Q(Qinv(PF_set(j))-sqrt(k));
    end
end

% GLRT Unknown Amplitude
i = 2;
plot_title(i) = {'GLRT A'};
PF(i,:) = 0.01:0.01:1;
PD(i,4,:) = Q(Qinv(PF(i,:)/2)-sqrt((ENR_fx))) + Q(Qinv(PF(i,:)/2)+sqrt(ENR_fx));
for j = 1:3
    for k = 1:length(ENR)
        PD(i,j,k) = Q(Qinv(PF_set(j)/2)-sqrt((k))) + Q(Qinv(PF_set(j)/2)+sqrt(k));
    end
end

% GLRT Unknown Amplitude, Phase
i = 3;
plot_title(i) = {'GLRT AP'};
PF(i,:) = 0.01:0.01:1;
for j = 1:100
    PD(i,4,j) = Qchipr2(nu, ENR_fx, 2*log(1/PF(i,j)), ep);
end
for j = 1:3
    for k = 1:length(ENR)
        PD(i,j,k) = Qchipr2(nu, k, 2*log(1/PF_set(j)), ep);
    end
end

% GLRT Unknown Amplitude, Phase, Frequency - 8 bins
i = 4;
K = 8;
plot_title(i) = {'GLRT APF K=8'};
PF(i,:) = 0.01:0.01:1;
for j = 1:100
    PD(i,4,j) = Qchipr2(nu, ENR_fx, (-2*log(1-nthroot((1-PF(i,j)),K))), ep);
end
for j = 1:3
    for k = 1:length(ENR)
        PD(i,j,k) = Qchipr2(nu, k, (-2*log(1-nthroot((1-PF_set(j)),K))), ep);
    end
end

% GLRT Unknown Amplitude, Phase, Frequency - 64 bins
i = 5;
K = 64;
plot_title(i) = {'GLRT APF K=64'};
PF(i,:) = 0.01:0.01:1;
for j = 1:100
    PD(i,4,j) = Qchipr2(nu, ENR_fx, (-2*log(1-nthroot((1-PF(i,j)),K))), ep);
end
for j = 1:3
    for k = 1:length(ENR)
        PD(i,j,k) = Qchipr2(nu, k, (-2*log(1-nthroot((1-PF_set(j)),K))), ep);
    end
end

% GLRT Unknown Amplitude, Phase, Frequency - Small PF estimate - 8 bins
i = 6;
K = 8;
plot_title(i) = {'GLRT APF, Small PF, K=8'};
PF(i,:) = 0.01:0.01:1;
for j = 1:100
    PD(i,4,j) = Qchipr2(nu, ENR_fx, (2*log(K/PF(i,j))), ep);
end
for j = 1:3
    for k = 1:length(ENR)
        PD(i,j,k) = Qchipr2(nu, k, (2*log(K/PF_set(j))), ep);
    end
end

% GLRT Unknown Amplitude, Phase, Frequency - Small PF estimate - 64 bins
i = 7;
K = 64;
plot_title(i) = {'GLRT APF, Small PF, K=64'};
PF(i,:) = 0.01:0.01:1;
for j = 1:100
    PD(i,4,j) = Qchipr2(nu, ENR_fx, (2*log(K/PF(i,j))), ep);
end
for j = 1:3
    for k = 1:length(ENR)
        PD(i,j,k) = Qchipr2(nu, k, (2*log(K/PF_set(j))), ep);
    end
end

%% Plots

%% PLOT ALL THE PLOTS ON ONE BIG ONE!, at least small and big

% Plot PF vs PD for all 5 detectors on one plot
figure;
fig = fig + 1;
for i = 1:7
    x = PF(i,:);
    y = reshape(PD(i,4,:),1,length(PD(i,4,:)));
    probpaper(x,y); hold on;
end
hold off; grid on;
title(['Fig ' num2str(fig) ' - PF vs PD for All Detectors']);
xlabel('PF'); ylabel('PD'); grid on;
legend(plot_title{1}, plot_title{2}, plot_title{3}, plot_title{4}, ...
    plot_title{5}, plot_title{6}, plot_title{7}, 'location', 'southeast');

% Plot the detectors with varying PF values
for i = 1:7
    figure
    fig = fig + 1;
    for j = 1:3
        x = 10*log10(ENR);
        y = reshape(PD(i,j,:),1,length(PD(i,j,:)));
        plot(x,y); hold on;
    end
    hold off; grid on;
    title(['Fig ' num2str(fig) ' - ' plot_title{i} ' PD vs ENR (dB)']);
    xlabel('ENR (dB)'); ylabel('PD'); grid on;
    legend('PF=10^{-1}','PF=10^{-2}','PF=10^{-3}', 'location', 'southeast');
end

% Plot the varying PF's on their own figures
for j = 1:3
    figure;
    fig = fig + 1;
    for i = 1:7
        x = 10*log10(ENR);
        y = reshape(PD(i,j,:),1,length(PD(i,j,:)));
        plot(x,y); hold on;
    end
    grid on;
    title(['Fig ' num2str(fig) ' - PD vs ENR (dB) for PF=10^{-' num2str(j) '}']);
    xlabel('ENR (dB)'); ylabel('PD'); grid on;
    legend(plot_title{1}, plot_title{2}, plot_title{3}, plot_title{4}, ...
        plot_title{5}, plot_title{6}, plot_title{7}, 'location', 'southeast');
end
