function [x_est,P_est,x_pred,P_pred,z_est,z_pred,S_kinv] = UKF(x_pred,P_pred,w,lambda,z,Q,R,k,T)

    
    X_pred = computeSigmaPoints(x_pred,P_pred,lambda);
    
    Z_pred = cell2mat(arrayfun(@(i) NLMeasurementModel(X_pred(:,i)), 1:size(X_pred,2),'UniformOutput',false));

    [z_pred,Pz] = computeMomentsFromSamples(w,Z_pred);
    S_k = Pz + R;
    S_kinv = inv(S_k);
    T_k = computeCrossCorrelationUKF(w,x_pred,z_pred,X_pred,Z_pred);
    K_k = T_k*S_kinv;
    
    epsilon = z - z_pred;  %Innovation
    x_est = x_pred + K_k*epsilon; %State update
    P_est = P_pred - K_k*S_k*K_k'; %error Covariance update
    
    z_est = NLMeasurementModel(x_est); %Estimated measurement

    
    X_est = computeSigmaPoints(x_est,P_est,lambda);
    
    X_pred = cell2mat(arrayfun(@(i) NLMotionModel(X_est(:,i),k,T), 1:size(X_est,2),'UniformOutput',false));
    
    [x_pred,Px] = computeMomentsFromSamples(w,X_pred);
    P_pred = Px + Q;
    
end

