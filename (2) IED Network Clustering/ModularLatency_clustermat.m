function inflect_pt = ModularLatency_clustermat( network)

%Determine clustering parameter
opt_mod          = 0;
gamma            = 0.5:0.1:2.5;
for ii           = 1:length(gamma)
    [~,iter_mod] = community_louvain(network,gamma(ii));
    opt_mod(ii)  = max(iter_mod);
end

%Compute inflection point
inflect_idx = ModularLatency_kneept(opt_mod);
inflect_pt  = gamma(inflect_idx);

end

