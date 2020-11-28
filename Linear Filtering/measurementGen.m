function [z_true, z_vector] = measurementGen(x_real,C,sigmaRsense)

numObs = size(x_real,2);

m = 2;

z_vector = zeros(m,numObs);
z_true = z_vector;
for k=1:numObs
    z_true(:,k) = measurementModel(x_real(:,k),C);
    z_vector(:,k) = z_true(:,k) + sqrt(sigmaRsense)*randn(m,1);
end

end

