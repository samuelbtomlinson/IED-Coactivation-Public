%{
    
    Spike co-activation represented in matrix form
    Co-activation = Spikes peaking within 150 ms 
    
    Inputs:
    - IEDs
    - nchans
    - srate (Hz)

    Outputs:
    - Network_N = number of coincident activations between pair (symmetric)
    - Network_C = co-activation rate (asymmetric, bound by 0-1)
    - Network_lags = mean lag (symmetric, bound by -150 to 150 ms)

    - N.B.: When visualizing the network_lags matrix, warm = upstream
    (negative lags --> inverse used for color plot purposes)


%}

function [network_N,network_C,network_lags] = ModularLatency_coincidence_150ms(ieds_IZ,nchans,srate)

[network_N,network_C,network_lags] = deal(zeros(nchans,nchans));

for chan = 1:nchans
    for spike_row = find(ieds_IZ(:,1)==chan)'      
        
        tix_1 = ieds_IZ(spike_row,2);
        coincident_spikes = find(abs(ieds_IZ(:,2)-tix_1)<srate/1000*150); %150 ms
        coincident_tix    = ieds_IZ(coincident_spikes,2);
        
        % Increment pairwise connection
        if ~isempty(coincident_spikes)
            for c2 = 1:length(coincident_spikes)
                coincident_chan = ieds_IZ(coincident_spikes(c2),1);
                network_N(chan,coincident_chan)=network_N(chan,coincident_chan)+1;
                latency = (tix_1 - coincident_tix(c2))*1000/srate;
                network_lags(chan,coincident_chan)=network_lags(chan,coincident_chan) + -1*latency;  % Inverse for color plotting        
            end
        end
        
    end
        
    % Normalize by number of spikes on the index channel
    network_C(chan,:)=network_N(chan,:)./length(find(ieds_IZ(:,1)==chan));
    
    % Set self to 0
    network_C(chan,chan)=0;
    network_N(chan,chan)=0;
end

% Take the average of pairwise network lags
network_lags = network_lags./network_N;



    