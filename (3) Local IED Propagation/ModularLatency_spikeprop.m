function spiketrains = ModularLatency_spikeprop(ieds,minstep,srate);

% This function iterates the IED matrix and extracts multi-channel
% spike sequences. Starts by appending all IEDs within 50ms then continues until
% last step >15ms from previous

% output:
%   -allseqs- each spike train = two adjacent columns (channels, tix)

overall   = [];         % will store all seqs
head      = ieds(1,:);   % first spike
currseq   = head;       % start building candidate sequency 

%Start at second row, add spikes to currseq until conditions violated
for row = 2:size(ieds,1)
    
    if ieds(row,2) - head(2) <= 50/(1000/srate) || ieds(row,2) - currseq(end,2) <= 15/(1000/srate)  
           
        currseq = vertcat(currseq,ieds(row,:));

    %Else, terminating spike has been reached
    else
        
        if size(currseq,1) >= minstep     %If seq contains at least 'minstep' spikes
            overall = ModularLatency_concatenate(currseq,overall);
            
        end
        
        %Update head and currseq
        head    = ieds(row,:);
        currseq = head;
        
    end
end

spiketrains = overall;

