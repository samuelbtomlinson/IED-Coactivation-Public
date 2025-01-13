function [ base ] = ModularLatency_concatenate( new,base )

diff = size(new,1) - size(base,1);

if diff < 0    
    new  = vertcat(new,zeros(abs(diff),size(new,2)));
elseif diff > 0
    base = vertcat(base, zeros(diff,size(base,2)));
end

base = [base,new];

end

