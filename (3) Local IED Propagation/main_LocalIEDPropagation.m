%% 
%{

Main inputs:
    seq_eeg       = sample EEG for Fig. 2E (clip x)    
    ieds_x        = sample spike trains from representative EEG clip x
    ieds_full     = community 1 IED detections from full EEG record
    chan_assign   = community assignments for each node
    chan_order    = sorted channel order (by community assignment)
    clust_chans   = nodes in community 1
    conn_IZ       = coactivation matrix (node x node x segment)
    allegiance_IZ = allegiance matrix (node x node)

%}

home_dir = pwd;
figure;

%% Load sample data (Fig. 2)
load('ModularLatency_sampledata_localpropagation.mat');

%% Plot IED network and allegiance matrix
ax(1)=subplot(5,6,[1:3,7:9]);
imagesc(nanmean(conn_IZ(chan_order,chan_order,:),3));caxis([0 0.3]);
title('Mean Coactivation (average across segments)'); 
xlabel('Node (sorted by community)'); ylabel('Node (sorted by community)');
colormap(ax(1),'parula');

ax(2)=subplot(5,6,[4:6,10:12]);
imagesc(allegiance_IZ(chan_order,chan_order));caxis([0 1]);
title('Allegiance'); 
xlabel('Node (sorted by community)'); ylabel('Node (sorted by community)');
colormap(ax(2),'parula');

%% Show example spike trains from sample EEG (for illustrative purposes, 
% bursts here were defined as IEDs involving >= 80% of community 1 nodes
n_clust_chans = length(clust_chans);
allseqs_x = ModularLatency_spikeprop(ieds_x,ceil(n_clust_chans*0.8),srate);

% Plot spike trains
ModularLatency_PlotSpikeTrains(allseqs_x,seq_eeg);

    
%% Detect spike trains from full-duration IED output (community #1)
% Here, use the threshold from methods section: >50% community nodes involved
allseqs_full = ModularLatency_spikeprop(ieds_full,ceil(n_clust_chans*0.5),srate);
n_trains     = size(allseqs_full,2)/2;

%Rasterize sequences
chans_only  = allseqs_full(:,1:2:end); chans_only(chans_only==0)=nan;
tix_only    = allseqs_full(:,2:2:end);
seq_rasters = nan(n_clust_chans,n_trains);

for i = 1:n_trains
    for chan = 1:n_clust_chans        
        f=min(find(chans_only(:,i)==clust_chans(chan)));
        if ~isempty(f)
            seq_rasters(chan,i)=tix_only(f,i)-tix_only(1,i);
        end
    end
end
seq_rasters=5.*seq_rasters; %convert to ms

ax(3)=subplot(5,6,25:28);
[yy,ii]=sort(nanmedian(seq_rasters,2));
h=pcolor(flipud(seq_rasters(ii,:)));
set(h,'EdgeColor','none'); colormap(ax(3),flipud(jet));  caxis([0 70])
xlabel('Spike Train (n)'); ylabel('Node (sorted)'); title('Activation Latency')
colorbar

%Plot median and IQR activation latency
ax(4)=subplot(5,6,29:30);
data=seq_rasters(ii,:);
for i = 1:n_clust_chans
    dd=data(i,:);
    dd(isnan(dd))=[];
    scatter(nanmedian(dd),i,'filled','k');hold on;
    line([prctile(dd,25),prctile(dd,75)],[i,i],'col','k');hold on;
end
set(gca,'ydir','reverse','xlim',[-5 75])
xlabel('Latency (ms)'); ylabel('Node (sorted)'); title('Activation Latency')
box on;




        
    
