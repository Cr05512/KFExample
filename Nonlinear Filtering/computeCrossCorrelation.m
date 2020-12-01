function T = computeCrossCorrelation(w,x,z,X,Z)

n = size(x,1);
m = size(z,1);
T = zeros(n,m);

for i=1:size(X,2)
    T = T + w(i)*(X(:,i)-x)*(Z(:,i)-z)';
end

end

