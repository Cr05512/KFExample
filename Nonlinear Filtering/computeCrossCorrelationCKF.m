function T = computeCrossCorrelationCKF(x,z,X,Z)

n = length(x);
m = length(z);
T = zeros(n,m);

for i=1:2*n
    T = T + (1/(2*n))*X(:,i)*Z(:,i)';
end
T = T - x*z';

end

