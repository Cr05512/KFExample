function [z_true, z_vector] = NLMeasurementGen(x_real,sigmaRsense)

numObs = size(x_real,2);

z_vector = zeros(1,numObs);
z_true = z_vector;
for k=1:numObs
    z_true(:,k) = NLMeasurementModel(x_real(:,k));
    z_vector(:,k) = z_true(:,k) + sqrt(sigmaRsense)*randn();
end

end

