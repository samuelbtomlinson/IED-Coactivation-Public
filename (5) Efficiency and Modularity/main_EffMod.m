%{

    Demonstrate calculation of efficiency and modularity across segments
    Representative patient = CHOP42
    Figure S3

    Inputs:
    >conn_IZ (node x node x segment IED co-activation matrix)
    >chan_assign (node community assignments)
    >chan_order (node vector sorted by communities)

%}

home_dir = pwd;
addpath(genpath(home_dir))

%% Load sample data (Fig. S3)
load('ModularLatency_sampledata_effmod.mat');

%% Iterate segments, calculate efficiency and modularity using Brain Connectivity Toolbox
nsegs = size(conn_IZ,3);
[eff,mod] = deal(nan(nsegs,1));
for s_i = 1:nsegs
    eff(s_i,1) = efficiency_wei(conn_IZ(:,:,s_i));
    [~,mod(s_i,1)]=community_louvain(conn_IZ(:,:,s_i));
end

%% Plot representative co-activation matrices sorted by efficiency
[yy,ii]=sort(eff);
trx=1;
for i = 50:50:300
    subplot(3,6,trx)
    imagesc(conn_IZ(chan_order,chan_order,ii(i)));caxis([0 0.2]);
    xlabel('Node'); ylabel('Node');
    trx=trx+1;
end

%% Plot thresholded networks for co-activation matrices
thresh = 0.2; %for plotting, show co-activations above threshold >0.2

%Build pseudo channel-coordinates based on community membership
xyChan=[];
scaler=3;
for i = 1:size(conn_IZ,1)
    m=chan_assign(chan_order(i));
    if m==1
        xyChan(i,:)=[1+rand(1)/scaler,2+rand(1)/scaler];
    elseif m==2
        xyChan(i,:)=[2+rand(1)/scaler,2+rand(1)/scaler];
    elseif m==3
        xyChan(i,:)=[1.5+rand(1)/scaler,1.5+rand(1)/scaler];
    elseif m==4
        xyChan(i,:)=[1+rand(1)/scaler,1+rand(1)/scaler];
    else
        xyChan(i,:)=[2+rand(1)/scaler,1+rand(1)/scaler];
    end
end

%Plot
trx=1;
for i = 50:50:300
    network=conn_IZ(chan_order,chan_order,ii(i));
    subplot(3,6,trx+6)
    for c1=1:size(network,1)
        for c2=1:size(network,1)
            if network(c1,c2)>thresh
                line([xyChan(c1,1),xyChan(c2,1)],[xyChan(c1,2),xyChan(c2,2)],'col',[0.6 0.6 0.6],'linewidth',0.5);hold on;
            end
        end
    end
    scatter(xyChan(:,1),xyChan(:,2),'filled','k');hold on;
    set(gca,'xlim',[0.75 2.75],'ylim',[0.75 2.75])
    trx=trx+1;
end

%% Plot efficiency vs modularity
subplot(3,6,13:15)
plot(eff(ii),'r'); hold on; plot(mod(ii),'b');
set(gca,'xlim',[1 nsegs]);
ylabel('Eff (Red), Mod (Blue)'); xlabel('Segment');

subplot(3,6,16:18)
scatter(eff,mod,'filled','k');
set(gca,'xlim',[0 0.3])
ylabel('Modularity'); xlabel('Efficiency');

