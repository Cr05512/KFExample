function Xi = computeThirdDegCubatureSet(x,P)
n = size(P,1);
sn = sqrt(n);
sP = real(sqrtm(P));
Xi = zeros(n,2*n);

for i=1:n
    Xi(:,i) = x + sn*sP(:,i);
    Xi(:,i+n) = x - sn*sP(:,i);
end

end

