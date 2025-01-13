function [allegiance_IZ,M_IZ] = ModularLatency_multilayermod(conn_IZ,iter_mod,gamma,omega);

n_chans = size(conn_IZ,1);
n_segs  = size(conn_IZ,3);
A = cell(n_segs,1);
for i = 1:n_segs
    A{i,1} = conn_IZ(:,:,i);
end

%Build multilayer dynamic matrix (M_IZ)
[B,twom] = multiord(A(:,1),gamma,omega);
[S,Q]    = genlouvain(B,[],0);
M_IZ     = reshape(S,[n_chans,n_segs]);

%Calculate allegiance matrix (allegiance_IZ)
allegiance_IZ = zeros(n_chans,n_chans);
for s = 1:n_segs
    for c1 = 2:n_chans
        for c2 = 1:c1-1
            if M_IZ(c1,s)==M_IZ(c2,s)
                allegiance_IZ(c1,c2)=allegiance_IZ(c1,c2)+1;
                allegiance_IZ(c2,c1)=allegiance_IZ(c2,c1)+1;
            end
        end
    end
end

allegiance_IZ = allegiance_IZ./n_segs;

end

