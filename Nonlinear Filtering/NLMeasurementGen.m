function [z_true, z_vector] = NLMeasurementGen(x_real,Rsense)

m = size(Rsense,1);
numObs = size(x_real,2);

z_vector = zeros(m,numObs);
z_true = z_vector;
for k=1:numObs
    z_true(:,k) = NLMeasurementModel(x_real(:,k));
    z_vector(:,k) = z_true(:,k) + mvnrnd(zeros(m,1),Rsense)';
end

end

