function [x_est,P_est,x_pred,P_pred,z_est,z_pred,S_kinv] = UKF(x_pred,P_pred,w,lambda,z,Q,R,k,T)
   
    [z_pred,S_k,X_pred,Z_pred] = UT(@NLMeasurementModel,x_pred,P_pred,w,lambda,R,k,T);
    S_kinv = inv(S_k);
    T_k = computeCrossCorrelation(w,x_pred,z_pred,X_pred,Z_pred);
    K_k = T_k*S_kinv;
    
    epsilon = z - z_pred;  %Innovation
    x_est = x_pred + K_k*epsilon; %State update
    P_est = P_pred - K_k*S_k*K_k'; %error Covariance update
    
    z_est = NLMeasurementModel(x_est); %Estimated measurement

    
    [x_pred,P_pred] = UT(@NLMotionModel,x_est,P_est,w,lambda,Q,k,T);
    
end

