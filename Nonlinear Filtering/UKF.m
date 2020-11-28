function [x_est,P_est,x_pred,P_pred,z_est,z_pred,S_kinv] = UKF(x_pred,P_pred,w,lambda,z,sigmaQ,sigmaR,k)

    
    X_pred = computeSigmaPoints(x_pred,P_pred,lambda);
    
    Z_pred = cell2mat(arrayfun(@(i) NLMeasurementModel1D(X_pred(:,i)), 1:size(X_pred,2),'UniformOutput',false));

    [z_pred,Pz] = computeMomentsSigmaPoints(w,Z_pred);
    S_k = Pz + sigmaR;
    S_kinv = inv(S_k);
    T = computeCrossCorrelationUKF(w,x_pred,z_pred,X_pred,Z_pred);
    K_k = T*S_kinv;
    
    epsilon = z - z_pred;  %Innovation
    x_est = x_pred + K_k*epsilon; %State update
    P_est = P_pred - K_k*S_k*K_k'; %error Covariance update
    
    z_est = NLMeasurementModel1D(x_est); %Estimated measurement

    
    X_est = computeSigmaPoints(x_est,P_est,lambda);
    
    X_pred = cell2mat(arrayfun(@(i) NLMotionModel1D(X_est(:,i),k), 1:size(X_est,2),'UniformOutput',false));
    
    [x_pred,Px] = computeMomentsSigmaPoints(w,X_pred);
    P_pred = Px + sigmaQ;
    
end

