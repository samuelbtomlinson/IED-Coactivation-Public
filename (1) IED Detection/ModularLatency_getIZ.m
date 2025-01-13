function [IZ,ieds_IZ] = ModularLatency_getIZ(ieds,iter_IZ,eegdur)

% Irritative zone
IZ       = [];
chans    = max(ieds(:,1));

spikemat = zeros(chans,iter_IZ+1);
spikemat(:,1) = histc(ieds(:,1),1:chans)./eegdur; %spikes/min

% Surrogate distribution
for iter = 2:iter_IZ+1
    spikemat(:,iter)=histc(randi(chans,length(ieds),1),1:chans)./eegdur;
end

% Determine IZ (mean + 1.5*SD)
IZ(:,1) = find(spikemat(:,1)>[mean(spikemat(:,2:end),2)+...
    1.5*std(spikemat(:,2:end),0,2)]);
IZ(:,2) = spikemat(IZ(:,1),1);

% Remap IED channel assigments to range from 1:max(IZ)
ieds_IZ = ieds(find(ismember(ieds(:,1),IZ(:,1))),:);
remap  = zeros(size(ieds_IZ,1),1);
for i  = 1:size(remap,1); remap(i,1)=find(ieds_IZ(i,1)==IZ(:,1)); end
ieds_IZ(:,1) = remap;

end

