function [errEllipsesVals,lambda,V] = errorEllipses(mu,P,nSigma)
n=size(mu,1); % Dimension or degrees of freedom

%We define the error value (confidence interval of uncertainty)
gamma = nSigma; %0.95=2*sigma, this is a percentile
%We compute the quantile for the desired percentile
k = chi2inv(gamma,n);
[V, D] = eig(P * k);
lambda = diag(D);

if n==1
    errEllipsesVals = [mu - V*sqrt(D); mu + V*sqrt(D)];
elseif n==2
    t = linspace(0, 2 * pi);
    errEllipsesVals = (V * sqrt(D)) * [cos(t(:))'; sin(t(:))'] + mu;
elseif n>2
    disp('Cannot process Gaussians with dimension greater than two.');
    return
end

end

