function x_real = NLTrajectoryGen(x0,Qsys,T,Tsim)

n = length(x0);
numSteps = Tsim/T; 
x_real = zeros(n,numSteps); %Scalar problem

x_real(:,1) = x0;

for k=2:numSteps
    x_real(:,k) = NLMotionModel(x_real(:,k-1),k-1,T) + mvnrnd(zeros(n,1),Qsys)';
end
    

end

