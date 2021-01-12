function [errEllipsesVals,lambda,V] = errorEllipses(mu,P,nSigma)
% [errEllipsesVals,lambda,V] = errorEllipses(mu,P,nSigma):
% INPUT:
% - mu, Gaussian Density mean (stateDim x 1 vector),
% - P, Gaussian Density covariance matrix (stateDim x stateDim matrix),
% - nSigma, percentile contours expressed as probability, e.g. 0.5, 0.95...(scalar).
% OUTPUT:
% - errEllipsesVals, vector containing error ellipse values,
% - lambda, eigenvalues of the error ellipse (stateDim x 1 vector),
% - V, eigenvectors of the error ellipse.
% This function generates the points for 1D and 2D error ellipses.
n=size(mu,1); % Dimension or degrees of freedom

%We define the error value (confidence interval of uncertainty)
gamma = nSigma; %0.95=2*sigma, this is a percentile
%We compute the quantile for the desired percentile
k = chi2inv(gamma,n);
[~, D, V] = svd(P * k);
lambda = diag(sqrt(D));

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

