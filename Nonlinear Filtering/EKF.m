function [x_est,P_est,x_pred,P_pred,z_est,z_pred,S_kinv] = EKF(x_pred,P_pred,z,Q,R,k,T)

    
    C = jacobianMeasModel(x_pred);
    z_pred = NLMeasurementModel(x_pred);
    S_k = C*P_pred*C' + R;
    S_kinv = inv(S_k);

    K_k = P_pred*C'*S_kinv;
    
    epsilon = z - z_pred;  %Innovation
    x_est = x_pred + K_k*epsilon; %State update
    P_est = P_pred - K_k*C*P_pred; %error Covariance update
    
    z_est = NLMeasurementModel(x_est); %Estimated measurement

    
    x_pred = NLMotionModel(x_est,k,T);
    A = jacobianMotionModel(x_est,k,T);
    P_pred = A*P_est*A' + Q;

end

