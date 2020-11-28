function [A,C,Q,R,n,m] = modelGen(modelName,T,sigmaQ,sigmaR)

if strcmpi(modelName,'CV') %Constant velocity

    n = 4;
    
    m = 2;
    
    A = [1 0 T 0;...
         0 1 0 T;...
         0 0 1 0;...
         0 0 0 1];

    C = [1 0 0 0;...  %We observe px and py only
         0 1 0 0];
     
    Q =    [T^3/3 0 T^2/2 0;...
            0 T^3/3 0 T^2/2;...
            T^2/2 0 T 0;...
            0 T^2/2 0 T];
        
%     %Perturbations on the real system
%     Qsys = sigmaQsys*Q;
    
    %Process noise covariance (filter)
    Q = sigmaQ*Q;
    
    R = sigmaR*eye(m); %Measurement noise covariance (filter)
%     
%     %Sensor noise covariance
%     Rsense = sigmaRsense*eye(m);

    
    
elseif strcmpi(modelName,'CA') %Constant acceleration
    
    n = 6;
    
    m = 2;

    A = [1 0 T 0 T^2/2 0;...
         0 1 0 T 0 T^2/2;...
         0 0 1 0 T 0;...
         0 0 0 1 0 T;...
         0 0 0 0 1 0;
         0 0 0 0 0 1];

    C = [1 0 0 0 0 0;...
         0 1 0 0 0 0];
     
    Q =     [T^5/20 0 T^4/8 0 T^3/6 0;...
             0 T^5/20 0 T^4/8 0 T^3/6;...
             T^4/8 0 T^3/3 0 T^2/2 0;...
             0 T^4/8 0 T^3/3 0 T^2/2;...
             T^3/6 0 T^2/2 0 T 0;...
             0 T^3/6 0 T^2/2 0 T];
        
%     %Perturbations on the real system
%     Qsys = sigmaQsys*Q;
    
    %Process noise covariance (filter)
    Q = sigmaQ*Q;
        
    R = sigmaR*eye(m); %Measurement noise covariance (filter)
%     
%     %Sensor noise covariance
%     Rsense = sigmaRsense*eye(m);

    
end


end

