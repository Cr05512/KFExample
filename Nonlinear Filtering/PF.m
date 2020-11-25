function [x_est, x_Part] = PF(x_Part,z,sigmaQ,sigmaR,k)

N = length(x_Part);

x_Part_upd = zeros(size(x_Part));
z_Part_pred = zeros(size(x_Part_upd));
w_P = zeros(length(x_Part));

%Correction
%We use the particles to compute the likelihoods

for i=1:N
    z_Part_pred(i) = NLMeasurementModel1D(x_Part(i));
    w_P(i) = normpdf(z,z_Part_pred(i),sqrt(sigmaR));
end

%Weight renormalization

w_P = w_P./sum(w_P);

w_cdf = cumsum(w_P);
%Update
for i=1:N
    x_Part_upd(i) = x_Part(find(rand <= w_cdf,1));
end

x_est = mean(x_Part_upd);

%Prediction

for i=1:N
    x_Part(i) = NLMotionModel1D(x_Part_upd(i),k) + sqrt(sigmaQ)*randn();
end

end

