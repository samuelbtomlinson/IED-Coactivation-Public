%{

    IED Detector - main script
    Original Publication: Brown et al. (doi: 10.1016/j.clinph.2007.04.017)
    
    Sample data: ModularLatency_sampledata_eeg.mat
    >srate = 200 Hz sampling rate
    eegdata = chan x samples (10 minutes of EEG activity, 110 channels)

    Output:
    ieds = IEDx2 matriFindPeaks.m (channel and time sample for each detected IED)    
  
%}

home_dir = pwd;
addpath(genpath(home_dir))

%% Load sample EEG data (10 mins)
load('ModularLatency_sampledata_eeg.mat'); % eegdata: chans (110) x samples (120000), srate = 200 Hz

%% Detect IEDs

% Run IED detector on 10-minute sample EEG
nchans = size(eegdata,1);
eegdur = size(eegdata,2)/srate/60; %mins
ieds   = ModularLatency_fspk2(eegdata,13,300,nchans,srate); %IED detector

%% Extract irritative zone

% IZ: irritative zone electrodes (column 1) and spikes/min (column 2)
% ieds_IZ: remapped ied to include only IZ electrodes
[IZ,ieds_IZ] = ModularLatency_getIZ(ieds,1000,eegdur);

%% Plot IEDs for each IZ electrode
spikewin = 500;                             %peri-spike plotting window (ms)
ModularLatency_plotIEDs(eegdata(IZ(:,1),:),size(IZ,1),ieds_IZ,spikewin,srate);

%% Construct IED co-activation network (IZ electrodes only)
[network_N,network_C,network_lags] = ModularLatency_coincidence_150ms(ieds_IZ,size(IZ,1),srate);
figure
ax(1)=subplot(121);
imagesc(network_C); caxis([0 0.3]); colorbar
xlabel('Node'); ylabel('Node'); title('Co-activation'); 
colormap(ax(1),'parula');
ax(2)=subplot(122);
imagesc(network_lags); caxis([-75 75]); colorbar
xlabel('Node'); ylabel('Node'); title('Latency (ms)'); 
colormap(ax(2),'jet');