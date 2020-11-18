function [x_pred,P_pred,x_est,P_est,z_pred,z_est] = KF(x_pred,P_pred,z,A,C,Q,R)

%The state vector is [x; v_x; y; v_y], that is we are estimating 2D
%cartesian position and velocity of a moving target.
%We can measure only the position.

%Correction
z_pred = measurementModel(x_pred,C);
S = C*P_pred*C' + R;
K_k = P_pred*C'*inv(S);

x_est = x_pred + K_k*(z - z_pred);
P_est = P_pred - K_k*C*P_pred;
norm(P_est)

z_est = measurementModel(x_est,C);
%Prediction

x_pred = motionModel(x_est,A);
P_pred = A*P_est*A' + Q;


end

