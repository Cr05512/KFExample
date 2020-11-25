function SigmaPoints = computeSigmaPoints(x,P,lambda)

n = size(x,1);
A = real(sqrtm((n+lambda)*P));

SigmaPoints = [x x+A x-A];

end

