function [x,P] = computeMomentsSigmaPoints(weights,SigmaPoints)

n = (length(weights)-1)/2;
x = zeros(size(SigmaPoints,1),1);
P = zeros(size(SigmaPoints,1),size(SigmaPoints,1));

for i=1:2*n+1
    x = x + weights(i)*SigmaPoints(:,i);
end

for i=1:2*n+1
    P = P + weights(i)*(SigmaPoints(:,i) - x)*(SigmaPoints(:,i) - x)';
end


end

