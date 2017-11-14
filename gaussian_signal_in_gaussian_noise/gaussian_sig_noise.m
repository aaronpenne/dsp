clear all; close all; clc;

%% Set parameters

N_set = [2 4 8 16 32 64];
N_rng = 2:2:64;

ENR_set_db  = [10 15];
ENR_set = 10.^(ENR_set_db/10);
ENR_rng_db = 20;
ENR_rng = 1:(10.^(ENR_rng_db/10));

PF_set = [10^-1, 10^-2, 10^-3];
PF_rng = 0.01:0.01:1;

plot_type = {'r', 'b', 'k', '--r', '--b', '--k', '-.r', '-.b', '-.k'};
plot_num = 0;
fig = 0;

%% I.C.1 PD vs PF

% ENR = 10, 15
% N = 2, 4, 8, 16, 32, 64
% PF = Variable
%
for i = 1:length(ENR_set)
    plot_num = plot_num+1;
    for j = 1:length(N_set)
        for k=1:length(PF_rng)
            PD(plot_num,j,k) = 1 - chi2cdf(chi2inv(1-PF_rng(k),N_set(j))/(ENR_set(i)/N_set(j)+1),N_set(j));
        end
        legend_pd_vs_pf(j) = {['N=' num2str(N_set(j))]};
    end
end

%% I.C.2 PD vs ENR

% PF = 10^-1, 10^-2, 10^-3
% N = 2, 4, 8, 16, 32, 64
% ENR = Variable
%
for i = 1:length(PF_set)
    plot_num = plot_num+1;
    for j = 1:length(N_set)
        for k=1:length(ENR_rng)
            PD(plot_num,j,k) = 1 - chi2cdf(chi2inv(1-PF_set(i),N_set(j))/(ENR_rng(k)/N_set(j)+1),N_set(j));
        end
        legend_pd_vs_enr(j) = {['N=' num2str(N_set(j))]};
    end
end

%% I.D PD vs N

% ENR = 10, 15
% PF = 10^-1, 10^-2, 10^-3
% N = Variable
%
for i = 1:length(ENR_set)
    plot_num = plot_num+1;
    for j = 1:length(PF_set)
        for k=1:length(N_rng)
            PD(plot_num,j,k) = 1 - chi2cdf(chi2inv(1-PF_set(j),N_rng(k))/(ENR_set(i)/N_rng(k)+1),N_rng(k));
        end
        legend_pd_vs_n(j) = {['PF=10^{-' num2str(j) '}']};
    end
end

% Get optimum values of N for each ENR and PF case
[N_max(1,1),N_max(1,2)] = max(PD(6,1,:));
[N_max(2,1),N_max(2,2)] = max(PD(6,2,:));
[N_max(3,1),N_max(3,2)] = max(PD(6,3,:));
[N_max(4,1),N_max(4,2)] = max(PD(7,1,:));
[N_max(5,1),N_max(5,2)] = max(PD(7,2,:));
[N_max(6,1),N_max(6,2)] = max(PD(7,3,:));
N_max(:,2)=N_max(:,2)*2;

%% Plots

% Plot PD vs PF
for i = 1:length(ENR_set)
    figure
    fig = fig+1;
    for j = 1:length(N_set)
        x = PF_rng;
        y = squeeze(PD(i,j,:));
        probpaper_mod(x,y,plot_type(j)); hold on;
    end
    hold off; grid on;
    title(['Fig ' num2str(fig) ' - PD vs PF for ENR=' num2str(ENR_set_db(i)) 'dB']);
    xlabel('PF'); ylabel('PD'); 
    legend(legend_pd_vs_pf, 'location', 'southeast');
end
incr = i+1;

% Plot PD vs ENR
for i = incr:(length(PF_set)+incr-1)
    figure
    fig = fig+1;
    for j = 1:length(N_set)
        x = 10*log10(ENR_rng);
        y = squeeze(PD(i,j,:));
        plot(x,y,plot_type{j}); hold on;
    end
    hold off; grid on;
    title(['Fig ' num2str(fig) ' - PD vs ENR for PF=10^{-' num2str(i-incr+1) '}']);
    xlabel('ENR (dB)'); ylabel('PD'); 
    legend(legend_pd_vs_enr, 'location', 'southeast');
end
incr = i+1;

% Plot PD vs N
for i = incr:(length(ENR_set)+incr-1)
    figure
    fig = fig+1;
    for j = 1:length(PF_set)
        x = N_rng;
        y = squeeze(PD(i,j,1:length(N_rng)));
        plot(x,y,plot_type{j}); hold on;
    end
    hold off; grid on;
    title(['Fig ' num2str(fig) ' - PD vs N for ENR=' num2str(ENR_set_db(i-incr+1)) 'dB']);
    xlabel('N'); ylabel('PD'); axis([2,64,0,1]);
    ax = gca; ax.XTick = [2 4 6 8 12 16 24 32 40 48 56 64];
    legend(legend_pd_vs_n, 'location', 'southeast');
end