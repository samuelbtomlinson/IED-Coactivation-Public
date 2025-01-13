%{ 

    Analyze features of slow wave across IED efficiency states
    
    Inputs:
    waveforms = 18x1 cell (each row = spikes from one 30-min segment)
    High efficiency = first 6 segments, Int = next 6, Low = last 6

%}

home_dir = pwd;

%% Load sample data (Fig. 6)
load('ModularLatency_sampledata_slowwavemorphology.mat');

%Encode number of spikes in each segment
%Extract all spike waveforms
spike_N = zeros(18,1);
allspikes = [];
for s_i = 1:18
    spike_N(s_i,1)=size(waveforms{s_i,1},1);
    allspikes=[allspikes;waveforms{s_i,1}];
end

%Number of spikes in high/int/low
n_higheff = sum(spike_N(1:6));
n_inteff = sum(spike_N(7:12));
n_loweff = sum(spike_N(13:18));

%ID vector encoding high/int/low
spike_id = [repmat(1,n_higheff,1);repmat(2,n_inteff,1);repmat(3,n_loweff,1)];

%Subset to lowest random matched number
subset=min([n_higheff,n_inteff,n_loweff]);
spikes_higheff=allspikes(spike_id==1,:);spikes_higheff=spikes_higheff(randperm(n_higheff,subset),:);
spikes_inteff=allspikes(spike_id==2,:);spikes_inteff=spikes_inteff(randperm(n_inteff,subset),:);
spikes_loweff=allspikes(spike_id==3,:);spikes_loweff=spikes_loweff(randperm(n_loweff,subset),:);

%Convert to zscores
spikes_higheff=zscore(spikes_higheff')';
spikes_inteff=zscore(spikes_inteff')';
spikes_loweff=zscore(spikes_loweff')';

%Plot spikes by efficiency state
figure
subplot(141); 
plot(linspace(-500,500,200),spikes_higheff','col',[0.8 0.8 0.8]); hold on;
plot(linspace(-500,500,200),nanmean(spikes_higheff,1),'r','linewidth',2)
xlabel('Time (ms)'); ylabel('Amplitude (Z)'); title('High Efficiency')
set(gca,'ylim',[-5 5])

subplot(142); 
plot(linspace(-500,500,200),spikes_inteff','col',[0.8 0.8 0.8]); hold on;
plot(linspace(-500,500,200),nanmean(spikes_inteff,1),'k','linewidth',2)
xlabel('Time (ms)'); ylabel('Amplitude (Z)'); title('Intermediate Efficiency')
set(gca,'ylim',[-5 5])

subplot(143); 
plot(linspace(-500,500,200),spikes_loweff','col',[0.8 0.8 0.8]); hold on;
plot(linspace(-500,500,200),nanmean(spikes_loweff,1),'b','linewidth',2)
xlabel('Time (ms)'); ylabel('Amplitude (Z)'); title('Low Efficiency')
set(gca,'ylim',[-5 5])

%Analyze spike morphology of grand-averaged waveforms
[sw_dur_high,sw_auc_high,sw_amp_high] = ModularLatency_spikemorphology(nanmean(spikes_higheff,1),200);
[sw_dur_int,sw_auc_int,sw_amp_int] = ModularLatency_spikemorphology(nanmean(spikes_inteff,1),200);
[sw_dur_low,sw_auc_low,sw_amp_low] = ModularLatency_spikemorphology(nanmean(spikes_loweff,1),200);

subplot(144); 
plot(linspace(-500,500,200),nanmean(spikes_higheff,1),'r','linewidth',2); hold on;
plot(linspace(-500,500,200),nanmean(spikes_inteff,1),'k','linewidth',2); hold on;
plot(linspace(-500,500,200),nanmean(spikes_loweff,1),'b','linewidth',2); hold on;
line([-500 500],[0 0],'col','k');
set(gca,'ylim',[-2 2],'xlim',[-500 500],'fontsize',8)
xlabel('Time (ms)'); ylabel('Amplitude (Z)'); title('Grand Average Waveforms')
