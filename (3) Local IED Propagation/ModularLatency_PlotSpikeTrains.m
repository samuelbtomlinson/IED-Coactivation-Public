function [] = ModularLatency_PlotSpikeTrains(allseqs,seq_eeg)

%Plot spike train EEG and raster data
chans_only= allseqs(:,1:2:end); chans_only(chans_only==0)=nan;
tix_only  = allseqs(:,2:2:end);

trk=1;
for i = [27,35,7,44,16,24] %illustrative spike trains
    subplot(5,6,12+trk)
    for j = 1:18
        plot(linspace(-500,500,201),j*300+seq_eeg(j,:,i),'col','k');
        title(['Spike Train ',num2str(trk)]);
        hold on;
    end
    set(gca,'ylim',[-1000 6500],'xlim',[-250 250],'ydir','reverse')
    xlabel('Latency (ms)'); ylabel('Node (sorted)');
    
    subplot(5,6,12+trk+6)
    for j = 1:18
        tmp=min(find(chans_only(:,i)==j));
        if ~isempty(tmp)
            lat=5*(tix_only(tmp,i)-tix_only(1,i));
            line([lat lat],[j-0.4 j+0.4],'col','k');hold on;        
        end
    end
    set(gca,'xlim',[-10 100],'ylim',[0 19],'ydir','reverse')
    xlabel('Latency (ms)'); ylabel('Node (sorted)');
    trk=trk+1;
end



end

