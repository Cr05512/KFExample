clc
clear
close all


%This script implements nonlinear filters on a 1D nonlinear model.
sigmaQ = 12; %Process noise tuning for the KF
sigmaR = 2; %Measurement noise tuning for the KF
sigmaQsys = 10; %Real system perturbations
sigmaRsense= 1; %Real sensor noise
sigmaXInit = 3; %Spread factor of the init estimate around the real state
sigmaPInit = 3; %Tuning parameter of the error estimate covariance

N_Particles = 50; %Note: by selecting a low number of particles you might incur in a total depletion. Select at least N=50
plotParticles = 0;

T = 0.1; %Sampling time
Tsim = 10; %Simulation time
n=1;
m=1;

%Data generation
x0 = 0.1;

x_true = NLTrajectoryGen(x0,sigmaQsys,T,Tsim);
[z_true, z_vector] = NLMeasurementGen(x_true,sigmaRsense); 

%First row = UKF
%Second row = PF

%Filtering
x_est = zeros(3,size(x_true,2)+1);
z_est = zeros(3,size(x_true,2));

%Filter init
x_pred = x0 + sqrt(sigmaXInit)*randn();
x_est(1:2) = x_pred*ones(2,1);
P_pred = rand();
P_pred = sqrt(sigmaPInit)*(P_pred*P_pred')*ones(2,1);

x_Part = x0 + sqrt(sigmaXInit)*randn(N_Particles,1);
x_est(3) = mean(x_Part);






P_est = zeros(3,1);
z_pred = zeros(3,1);


numSteps = size(z_vector,2); %The number of filter iterations is equal to the number of observations we do
Part_vec = zeros(N_Particles,numSteps);

%UKF
lambda = 1;
w = computeWeights(n,lambda);
exec_times = zeros(3,1);

for k=1:numSteps
    tic;
    [x_est(1,k+1),P_est(1),x_pred,P_pred(1),z_est(1,k),z_pred(1),~]=UKF(x_pred,P_pred(1),w,lambda,z_vector(k),sigmaQ,sigmaR,k);
    exec_times(1) = exec_times(1) + toc;
    
    tic;
    [x_est(2,k+1),P_est(2),x_pred,P_pred(2),z_est(1,k),z_pred(2),~]=EKF(x_pred,P_pred(2),z_vector(k),sigmaQ,sigmaR,k);
    exec_times(2) = exec_times(1) + toc;
    

    tic;
    [x_est(3,k+1),x_Part,x_Part_upd]=PF(x_Part,z_vector(k),sigmaQ,sigmaR,k);
    Part_vec(:,k) = x_Part_upd;
    exec_times(3) = exec_times(2) + toc;

    
end

figure(1)
subplot(3,1,1)

plot(T:T:Tsim,x_true); hold on
plot(0:T:Tsim,x_est(1,:)); hold on
grid minor
legend('True trajectory','UKF estimate');
xlabel('t');
ylabel('p');
title(strcat(['UKF estimate. Execution time: ',' ',num2str(exec_times(1)),'s']));

subplot(3,1,2)

plot(T:T:Tsim,x_true); hold on
plot(0:T:Tsim,x_est(2,:)); hold on
grid minor
legend('True trajectory','EKF estimate');
xlabel('t');
ylabel('p');
title(strcat(['EKF estimate. Execution time: ',' ',num2str(exec_times(2)),'s']));

subplot(3,1,3)

plot(T:T:Tsim,x_true); hold on
plot(0:T:Tsim,x_est(3,:)); hold on
if plotParticles==1
    for k=1:numSteps
        plot(k*T,Part_vec(:,k),'.k'); hold on
    end
end
grid minor
legend('True trajectory','PF estimate');
xlabel('t');
ylabel('p');
title(strcat(['PF estimate. Execution time: ',' ',num2str(exec_times(3)),'s',' ','N=',num2str(N_Particles)]));

figure(2)

RMSE_UKF = x_true-x_est(1,2:end);
RMSE_UKF = sum(RMSE_UKF,1).^2 / n;
RMSE_UKF = sqrt(RMSE_UKF);
mean(RMSE_UKF)

RMSE_EKF = x_true-x_est(2,2:end);
RMSE_EKF = sum(RMSE_EKF,1).^2 / n;
RMSE_EKF = sqrt(RMSE_EKF);
mean(RMSE_EKF)

RMSE_PF = x_true-x_est(3,2:end);
RMSE_PF = sum(RMSE_PF,1).^2 / n;
RMSE_PF = sqrt(RMSE_PF);
mean(RMSE_PF)

plot(T:T:Tsim,RMSE_UKF); hold on
plot(T:T:Tsim,RMSE_EKF); hold on
plot(T:T:Tsim,RMSE_PF); hold on
grid minor
title('Error between true and estimated state')
legend('RMSE UKF','RMSE EKF','RMSE PF')



