clc
clear
close all


%This script implements a standard Kalman filter on a 2D constant velocity
%and acceleration models.
sigmaQKF = 2; %Process noise tuning for the KF
sigmaRKF = 5; %Measurement noise tuning for the KF
sigmaQsys = 0.2; %Real system perturbations
sigmaRsense= 4; %Real sensor noise
sigmaXInit = 3; %Spread factor of the init estimate around the real state
sigmaPInit = 6; %Tuning parameter of the error estimate covariance

T = 0.1; %Sampling time
Tsim = 10; %Simulation time
g = 9.81; %Gravity

modelName = 'CA'; %CV for constant velocity, CA for constant acceleration

%Model parameters
[A,C,QKF,RKF,n,m] = modelGen(modelName,T,sigmaQKF,sigmaRKF); 



%Initial state
if strcmpi(modelName,'CV')
    x0 = [0;0;9;30]; %Constant velocity
elseif strcmpi(modelName,'CA')
    x0 = [0;0;9;30;0;-g]; %Constant acceleration
end

%Data generation
x_true = trajectoryGen(x0,A,sigmaQsys,T,Tsim);
[z_true, z_vector] = measurementGen(x_true,C,sigmaRsense); 


%Filtering
x_est_vec = zeros(size(x_true,1),size(x_true,2)+1);
z_est_vec = zeros(size(z_vector));
nis_vec = zeros(size(z_vector,2),1);

%Note the x_est vector contains one more element (the initial guess) in
%order to show how a wrong init of the filter can be handled

%Filter init
x_pred = x0 + mvnrnd(zeros(n,1),sigmaXInit*eye(n))';
x_est_vec(:,1) = x_pred;

P_pred = rand(n,n);
P_pred = sigmaPInit*(P_pred*P_pred');


numSteps = size(z_vector,2); %The number of filter iterations is equal to the number of observations we do


for k=1:numSteps
    [x_est,P_est,x_pred,P_pred,z_est,z_pred,S_kinv]=KF(x_pred,P_pred,z_vector(:,k),A,C,QKF,RKF);
    x_est_vec(:,k+1) = x_est;
    z_est_vec(:,k) = z_est;
    nis_vec(k) = (z_vector(:,k)-z_pred)'*S_kinv*(z_vector(:,k)-z_pred);
end

%2D position plot
figure(1)
plot(x_true(1,:),x_true(2,:)); hold on
plot(x_est_vec(1,:),x_est_vec(2,:)); hold on
scatter(z_vector(1,:),z_vector(2,:)); hold on
plot(x_est_vec(1,1),x_est_vec(2,1),'+','MarkerSize',14,'LineWidth',14,'Color','r'); hold on
plot(x_true(1,1),x_true(2,1),'+','MarkerSize',14,'LineWidth',14,'Color','b'); hold on
plot(x_est_vec(1,end),x_est_vec(2,end),'p','MarkerSize',14,'LineWidth',14,'Color','r'); hold on
plot(x_true(1,end),x_true(2,end),'p','MarkerSize',14,'LineWidth',14,'Color','b'); hold on
grid minor
xlabel('p_x');
ylabel('p_y');

legend('True position','Estimated position','Observations');

figure(2)

RMSE = x_true-x_est_vec(:,2:end);
RMSE = sum(RMSE,1).^2 / n;
RMSE = sqrt(RMSE);

plot(T:T:Tsim,RMSE);
grid minor
title('Error between true and estimated state')
legend('RMSE')

figure(3)
subplot(1,2,1)
plot(T:T:Tsim,z_true(1,:)); hold on
plot(T:T:Tsim,z_vector(1,:)); hold on
plot(T:T:Tsim,z_est_vec(1,:)); hold on
grid minor
legend('z1_{true}','z1_{noise}','z1_{est}');
xlabel('t');
ylabel('p_x');
subplot(1,2,2)
plot(T:T:Tsim,z_true(2,:)); hold on
plot(T:T:Tsim,z_vector(2,:)); hold on
plot(T:T:Tsim,z_est_vec(2,:)); hold on
grid minor
legend('z2_{true}','z2_{noise}','z2_{est}');
xlabel('t');
ylabel('p_y');

figure(4)
plot(1:numSteps,nis_vec); hold on
yline(chi2inv(0.95,m),'-.r',num2str(chi2inv(0.95,m))); hold on
legend('Norm. Inn. Squared','Threshold');
title(strcat(['Normalized Innovation Squared Test: ',num2str(NISTest(nis_vec,m)*100),'% in range.']));
grid minor
axis([0 length(nis_vec) 0 chi2inv(0.95,m)*1.5])





