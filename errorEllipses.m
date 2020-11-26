function [errEllipsesVals,lambda,V] = errorEllipses(mu,P,nSigma)
n=size(mu,1); % Dimension or degrees of freedom
if n>2
    disp('Cannot process Gaussians with dimension greater than two.');
    return
end

%We define the error value (confidence interval of uncertainty)
gamma = nSigma; %0.95=2*sigma, this is a percentile
%We compute the quantile for the desired percentile
k = chi2inv(gamma,n);

%We compute the directions (eigenvectors) of the ellipse and the modules
%(eigenvalues)

[V, D] = eig(P * k);

t = linspace(0, 2 * pi);
errEllipsesVals = (V * sqrt(D)) * [cos(t(:))'; sin(t(:))'] + mu;

lambda = diag(D);

end

