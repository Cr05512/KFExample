function [x_est,P_est,x_pred,P_pred,z_est,z_pred,S_kinv] = EKF(x_pred,P_pred,z,sigmaQ,sigmaR,k)

    
    C = jacobianMeasModel(x_pred);
    z_pred = NLMeasurementModel1D(x_pred);
    S_k = C*P_pred*C' + sigmaR;
    S_kinv = inv(S_k);

    K_k = P_pred*C'*S_kinv;
    
    epsilon = z - z_pred;  %Innovation
    x_est = x_pred + K_k*epsilon; %State update
    P_est = P_pred - K_k*C*P_pred; %error Covariance update
    
    z_est = NLMeasurementModel1D(x_est); %Estimated measurement

    
    x_pred = NLMotionModel1D(x_est,k);
    A = jacobianMotionModel(x_est,k);
    P_pred = A*P_est*A' + sigmaQ;

end

