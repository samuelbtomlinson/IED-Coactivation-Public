kept_idx = find(cell2mat(SegmentData(:,1))==1);
badchans_matrixrow(badchans_matrixrow>chans)=[];
A=SegmentData(kept_idx,3);
for seg = 1:size(A,1)
    tmp = A{seg,1};
    tmp(isnan(tmp))=0;
    tmp(badchans_matrixrow,:)=[];
    tmp(:,badchans_matrixrow)=[];
    for cc = 1:size(tmp,1)
        tmp(cc,cc)=0;
    end
    
    %A{seg,1}=tmp;
    
    %Surrogate
    foo=zeros(size(tmp));
    vals=[]; for r = 2:size(tmp,1); for c = 1:r-1; vals=[vals;tmp(r,c)];end;end
    vals=vals(randperm(length(vals)));
    idx=1;
    for r = 2:size(tmp,1)
        for c = 1:r-1
            foo(r,c)= vals(idx);
            idx=idx+1;
        end
    end
    A{seg,1}=foo+foo';
end

[B,twom] = multiord(A,1,1);
[S,Q] = genlouvain(B);
M_temporal = reshape(S,[cc,seg]);
Allegiance =zeros(cc,cc);
for s = 1:seg
    for c1 = 2:cc
        for c2 = 1:c1-1
            if M_temporal(c1,s)==M_temporal(c2,s)
                Allegiance(c1,c2)=Allegiance(c1,c2)+1;
                Allegiance(c2,c1)=Allegiance(c2,c1)+1;
            end
        end
    end
end
Allegiance=Allegiance./s;

[infl_pt] = TimeVaryingGlobal_clustermat(Allegiance);
[chan_assign,Q] = community_louvain(Allegiance,infl_pt);
[yy,chan_order] = sort(chan_assign);

Flexibility = zeros(cc,1);
for i = 1:cc
    x=diff(M_temporal(i,:)); x(x~=0)=1;
    Flexibility(i,1)=sum(x)/(length(x));
end