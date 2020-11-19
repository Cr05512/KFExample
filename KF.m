function [x_est,P_est,x_pred,P_pred,z_est,z_pred] = KF(x_pred,P_pred,z,A,C,Q,R)

%The state vector is [x; v_x; y; v_y], that is we are estimating 2D
%cartesian position and velocity of a moving target.
%We can measure only the position.

%Correction
z_pred = measurementModel(x_pred,C); %Predicted measurement
S = C*P_pred*C' + R;  %Innovation covariance
K_k = P_pred*C'*inv(S); %Kalman Gain

epsilon = z - z_pred;  %Innovation
x_est = x_pred + K_k*epsilon; %State update
P_est = P_pred - K_k*C*P_pred; %error Covariance update

z_est = measurementModel(x_est,C); %Estimated measurement

%Prediction

x_pred = motionModel(x_est,A); %State prediction
P_pred = A*P_est*A' + Q; %error covariance prediction





end

