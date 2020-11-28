function x_true = userDefTrajectory(x0,sigmaQsys,T,Tsim)

n = size(x0,1);
numSteps = Tsim/T;

x_true = zeros(n,numSteps);
x_true(:,1) = x0;

v_traj = zeros(2,numSteps);
v_traj(:,1) = x0(3:4);

for k=2:numSteps
    if k<numSteps/2
        v_traj(:,k) = [x0(3)*cos(4*pi*k/numSteps);x0(4)*sin(4*pi*k/numSteps)];
        x_true(:,k) = [x_true(1:2,k-1) + v_traj(:,k-1)*T;v_traj(:,k)] + sqrt(sigmaQsys)*randn(n,1);
    else
        v_traj(:,k) = [x0(3)*cos(4*pi*k/numSteps);-x0(4)*sin(4*pi*k/numSteps)];
        x_true(:,k) = [x_true(1:2,k-1) + v_traj(:,k-1)*T;v_traj(:,k)] + sqrt(sigmaQsys)*randn(n,1);
    end
end


end

