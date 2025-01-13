function [] = ModularLatency_plotIEDs(eegdata,nchans,ieds,spikewin,srate)

figure

%Convert spike window to samples (tix)
spiketix = spikewin/1000*srate;

for i = 1:nchans
    
    % Get IEDs for index electrode
    ieds_i = find(ieds(:,1)==i);
    tix_i  = ieds(ieds_i,2);
    tix_i(find(tix_i<spiketix | tix_i>size(eegdata,2)-spiketix))=[];    
    
    if ~isempty(tix_i)
        
        % Get IED waveforms
        waveforms = [];
        for j = 1:length(tix_i)            
            waveforms(:,j) = eegdata(i,tix_i(j)-spiketix:tix_i(j)+spiketix)';
        end
        
        % Plot IED waveforms
        subplot(6,ceil(nchans/6),i)
        plot(linspace(-spikewin,spikewin,spiketix*2+1),waveforms,'col',[0.8 0.8 0.8]);hold on;
        plot(linspace(-spikewin,spikewin,spiketix*2+1),nanmean(waveforms,2),'col','r','linewidth',2);
        title(['Electrode: ', num2str(i)]);
        xlabel('Time (ms)');
        set(gca,'xlim',[-spikewin,spikewin]);
    end            
end
