function T = computeCrossCorrelationUKF(weights,x,z,X,Z)

n = length(x);
m = length(z);
T = zeros(n,m);

for i=1:2*n+1
    T = T + weights(i)*(X(:,i) - x)*(Z(:,i) - z)';
end

end

