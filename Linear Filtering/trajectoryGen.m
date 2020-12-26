function x_real = trajectoryGen(x0,A,Qsys,dt,Tsim)

n = size(x0,1);
numSteps = Tsim/dt; 
x_real = zeros(n,numSteps);

x_real(:,1) = x0;

for k=2:numSteps
    x_real(:,k) = motionModel(x_real(:,k-1),A) + mvnrnd(zeros(n,1),Qsys)';
end
    

end

