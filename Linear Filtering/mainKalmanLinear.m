clc
clear
close all


%This script implements a standard Kalman filter on a 2D constant velocity
%and acceleration models.
sigmaQKF = 0.5; %Process noise tuning for the KF
sigmaRKF = 4; %Measurement noise tuning for the KF
sigmaQsys = 0.1; %Real system perturbations
sigmaRsense= 2; %Real sensor noise
sigmaXInit = 50; %Spread factor of the init estimate around the real state
sigmaPInit = 50; %Tuning parameter of the error estimate covariance

T = 0.1; %Sampling time
Tsim = 10; %Simulation time
g = 9.81; %Gravity

modelName = 'CA'; %CV for constant velocity, CA for constant acceleration
trajGen = 'model'; 
dynPlot = 0;

%Model parameters
[A,C,QKF,RKF,n,m] = modelGen(modelName,T,sigmaQKF,sigmaRKF); 



%Initial state
if strcmpi(modelName,'CV')
    x0 = [0;0;-9;9]; %Constant velocity
elseif strcmpi(modelName,'CA')
    x0 = [0;0;9;30;0;-g]; %Constant acceleration
end

%Data generation
if strcmpi(trajGen,'model')
    x_true = trajectoryGen(x0,A,sigmaQsys,T,Tsim);
elseif strcmpi(trajGen,'UD')
    x_true = userDefTrajectory(x0,sigmaQsys,T,Tsim);
end
[z_true, z_vector] = measurementGen(x_true,C,sigmaRsense); 


%Filtering
x_est_vec = zeros(n,size(x_true,2)+1);
z_est_vec = zeros(size(z_vector));
P_est_vec = zeros(n,n,size(x_true,2)+1);

%Consistency
nis_vec = zeros(size(z_vector,2),1);
alpha = 0.95;

%Note the x_est vector contains one more element (the initial guess) in
%order to show how a wrong init of the filter can be handled

%Filter init
x_pred = x0 + sqrt(sigmaXInit)*randn(n,1);
x_est_vec(:,1) = x_pred;


P_pred = rand(n,n);
P_pred = sigmaPInit*(P_pred*P_pred');
P_est_vec(:,:,1) = P_pred;


numSteps = size(z_vector,2); %The number of filter iterations is equal to the number of observations we do



for k=1:numSteps
    [x_est,P_est,x_pred,P_pred,z_est,z_pred,S_kinv]=KF(x_pred,P_pred,z_vector(:,k),A,C,QKF,RKF);
    x_est_vec(:,k+1) = x_est;
    P_est_vec(:,:,k+1) = P_est;
    z_est_vec(:,k) = z_est;
    nis_vec(k) = (z_vector(:,k)-z_pred)'*S_kinv*(z_vector(:,k)-z_pred);
    
    
end


if dynPlot==1
    f1 = figure(1);
    grid minor
    hold on
    axis([min(x_est_vec(1,:))-10 max(x_est_vec(1,:))+10 min(x_est_vec(2,:))-10 max(x_est_vec(2,:))+10]);
    axis square

    pause()

    for k=1:numSteps
        h1 = plot(x_true(1,k),x_true(2,k),'-bx','LineWidth',14); hold on; 
        plot(x_true(1,1:k),x_true(2,1:k),'-b'); hold on; 
        scatter(z_vector(1,k),z_vector(2,k),'ko'); hold on
        h2 = plot(x_est_vec(1,k+1),x_est_vec(2,k+1),'-r+','LineWidth',14); hold on;
        plot(x_est_vec(1,1:k+1),x_est_vec(2,1:k+1),'-.r'); hold on;
        [errEllipse,lambda,V] = errorEllipses(x_est_vec(1:2,k+1),P_est_vec(1:2,1:2,k+1),alpha);
        hEll = plot(errEllipse(1,:),errEllipse(2,:),':m','LineWidth',2); hold on

        pause(0.1)
        if k<numSteps
            set(h1,'Visible','off');
            set(h2,'Visible','off');
            set(hEll,'Visible','off');
        end
    end

    pause()

    close(f1);
end

%2D position plot
figure(2)
plot(x_true(1,:),x_true(2,:),'-b'); hold on
plot(x_est_vec(1,:),x_est_vec(2,:),'-.r'); hold on
scatter(z_vector(1,:),z_vector(2,:),'k'); hold on
plot(x_est_vec(1,1),x_est_vec(2,1),'+','MarkerSize',14,'LineWidth',14,'Color','r'); hold on
plot(x_true(1,1),x_true(2,1),'+','MarkerSize',14,'LineWidth',14,'Color','b'); hold on
plot(x_est_vec(1,end),x_est_vec(2,end),'p','MarkerSize',14,'LineWidth',14,'Color','r'); hold on
plot(x_true(1,end),x_true(2,end),'p','MarkerSize',14,'LineWidth',14,'Color','b'); hold on
grid minor
xlabel('p_x');
ylabel('p_y');
legend('True trajectory','Estimated trajectory','Observations');


figure(3)

RMSE_KF = RMSE(x_true,x_est_vec(:,2:end));

plot(T:T:Tsim,RMSE_KF);
grid minor
title('Error between true and estimated state')
legend('RMSE')

figure(4)
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

NISTest(nis_vec,alpha,m);






