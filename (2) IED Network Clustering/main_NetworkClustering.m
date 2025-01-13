home_dir = pwd;
addpath(genpath(home_dir))

%% Load sample data
%conn_IZ = chan x chan x segment co-activation matrix 
%lags_IZ = chan x chan x segment latency matrix
load('ModularLatency_sampledata_IEDnetworks.mat'); 

%% Perform multilayer modularity clustering
[allegiance_IZ,M_IZ] = ModularLatency_multilayermod(conn_IZ,1000,1,1);

%Detect communities from allegiance matrix and channel assign
infl_pt = ModularLatency_clustermat(allegiance_IZ);
[chan_assign,~] = community_louvain(allegiance_IZ,infl_pt);
[~,chan_order]  = sort(chan_assign);

%% Display results 
% (N.B.- due to randomization that occurs during multilayer modularity, 
% results here may vary slightly from those in Fig. 1 and will fluctuate
% from run to run)

ax(1)=subplot(2,3,1);
imagesc(nanmean(conn_IZ(chan_order,chan_order,:),3));caxis([0 0.3]);
title('Mean Coactivation (average across segments)'); 
xlabel('Node (sorted by community)'); ylabel('Node (sorted by community)');
colormap(ax(1),'parula');

ax(2)=subplot(2,3,4);
imagesc(nanmean(lags_IZ(chan_order,chan_order,:),3));caxis([-50 50]);
title('Mean Latency, ms (average across segments)'); 
xlabel('Node (sorted by community)'); ylabel('Node (sorted by community)');
colormap(ax(2),'jet');

ax(3)=subplot(2,3,2:3);
imagesc(M_IZ(chan_order,:)); 
title('Multilayer Modularity'); xlabel('Segment'); ylabel('Node (sorted by community)');

ax(4)=subplot(2,3,5:6);
imagesc(allegiance_IZ(chan_order,chan_order));caxis([0 1]);
title('Allegiance'); xlabel('Node (sorted by community)'); ylabel('Node (sorted by community)');
colorbar


