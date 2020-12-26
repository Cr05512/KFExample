function res = RMSE(x,y)
% result = RMSE(x,y)
% - x,y , xDim x T matrices
T = size(x,2);
xDim = size(x,1);

res = 0;

for i=1:T
    diff = x(:,i) - y(:,i);
    sq_diff = diff'*diff;
    res = res + sq_diff;
    
end

res = sqrt(res/T);

    
end

