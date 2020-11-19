clc
clear
close all

%This script implements a standard Kalman filter on a 2D constant velocity
%and acceleration models.
sigmaQKF = 0.1; %Process noise tuning for the KF
sigmaRKF = 2; %Measurement noise tuning for the KF
sigmaQsys = 0.1; %Real system perturbations
sigmaRsense= 2; %Real sensor noise
T = 0.1; %Sampling time
Tsim = 6; %Simulation time
g = 9.81; %Gravity

model = 'CA'; %CV for constant velocity, CA for constant acceleration

%Model parameters
[A,C,Q,R,n,m] = modelGen(model,T,sigmaQKF,sigmaRKF); 



%Initial state
if strcmpi(model,'CV')
    %Sensor noise covariance
    Rsense = sigmaRsense*eye(m);

    %Perturbations on the real system
    Qsys = sigmaQsys*eye(n);
    
    x0 = [0;0;10;10]; %Constant velocity
elseif strcmpi(model,'CA')
    %Sensor noise covariance
    Rsense = sigmaRsense*eye(m);

    %Perturbations on the real system
    Qsys = sigmaQsys*[1 0 0 0 0 0;...
                      0 1 0 0 0 0;...
                      0 0 1 0 0 0;...
                      0 0 0 1 0 0;...
                      0 0 0 0 0 0;...
                      0 0 0 0 0 0];
    x0 = [0;0;9;30;0;-g];
end

%Data generation
x_true = trajectoryGen(x0,A,Qsys,T,Tsim);
[z_true, z_vector] = measurementGen(x_true,C,Rsense);

%Filtering
x_est_vec = zeros(size(x_true));
z_est_vec = zeros(size(z_vector));

%Filter init
x_pred = x0 + 3*randn(n,1);
P_pred = rand(n,n);
P_pred = 3*P_pred*P_pred';

numSteps = Tsim/T;

for k=1:numSteps
    [x_pred,P_pred,x_est,P_est,z_pred,z_est]=KF(x_pred,P_pred,z_vector(:,k),A,C,Q,R);
    x_est_vec(:,k) = x_est;
    z_est_vec(:,k) = z_est;
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

legend('True position','Estimated position','Observations');

figure(2)
subplot(1,2,1)
plot(T:T:Tsim,z_true(1,:)); hold on
plot(T:T:Tsim,z_vector(1,:)); hold on
plot(T:T:Tsim,z_est_vec(1,:)); hold on
grid minor
legend('z1_{true}','z1_{noise}','z1_{est}');
subplot(1,2,2)
plot(T:T:Tsim,z_true(2,:)); hold on
plot(T:T:Tsim,z_vector(2,:)); hold on
plot(T:T:Tsim,z_est_vec(2,:)); hold on
grid minor
legend('z2_{true}','z2_{noise}','z2_{est}');





