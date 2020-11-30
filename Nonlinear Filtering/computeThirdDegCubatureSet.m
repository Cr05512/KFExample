function Xi = computeThirdDegCubatureSet(x,P)
n = size(P,1);
sn = sqrt(n);
sP = real(sqrtm(P));
Xi = [x+sn*sP x-sn*sP];

end

