function [sw_dur,sw_auc,sw_amp] = ModularLatency_spikemorphology(A,srate)

%Get time of peak closest to 0 (should be ~100tix)
[~,LOCS] = findpeaks(abs(A));
npeaks=length(LOCS); V=repmat(100,[1 npeaks]);
[~,closestIndex] = min(abs(LOCS-V));

%First SW peak (aka- large negative peak around 0 time point)
firstSWpeak=LOCS(closestIndex);

%Second SW peak
secondSWpeak=LOCS(closestIndex+1);

%Third SW peak
thirdSWpeak=LOCS(closestIndex+2);

%SW dur (first peak to third SW peak)
sw_dur=1000*(thirdSWpeak-firstSWpeak)/srate; %millisec

%SW auc (abs area between first and third SW peak)
tmp = A(firstSWpeak:thirdSWpeak);
sw_auc=trapz(abs(tmp));

%SW amplitude (first to second peak)
sw_amp = A(secondSWpeak)-A(firstSWpeak);

end




