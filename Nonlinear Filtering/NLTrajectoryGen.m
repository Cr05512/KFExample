function x_real = NLTrajectoryGen(x0,sigmaQsys,dt,Tsim)

numSteps = Tsim/dt; 
x_real = zeros(1,numSteps); %Scalar problem

x_real(1) = x0;

for k=2:numSteps
    x_real(k) = NLMotionModel1D(x_real(k-1),k-1) + sqrt(sigmaQsys)*randn();
end
    

end

