function [errEllipsesVals,V,lambda] = errorEllipses(mu,P,nSigma,nPoints)
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

[V,lambda] = eig(P); %V eigenvectors, lambda eigenvalues
lambda = diag(lambda);

%Find the index for the largest eigenvector (the one corresponding to the
%largest eigenvalue)
[~,indmax] = max(lambda);
%Index for the smallest eigenvalue
[~,indmin] = min(lambda);

%Compute the rotation of the ellipse as:
alpha = atan2(V(2,indmax),V(1,indmax));
%Atan2 is defined in the interval [-pi,pi]. We want it to be in [0,2*pi]
if alpha < 0
    alpha = alpha + 2*pi;
end

%We build the rotation matrix for such angle
R = [cos(alpha) sin(alpha);-sin(alpha) cos(alpha)];

%We compute the ellipses values in the case of axis-aligned data
N = nPoints; %Number of points used to plot the ellipse
theta = 0:pi/N:2*pi; %Angle values
a = sqrt(lambda(indmax)*k);
b = sqrt(lambda(indmin)*k);
errEllipsesVals = ([a*cos(theta);b*sin(theta)]'*R)' + mu;

V = [V(:,indmax) V(:,indmin)];
lambda = [lambda(indmax);lambda(indmin)];

end

