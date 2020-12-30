function res = RMSE(x,y)
% result = RMSE(x,y)
% - x,y , xDim x T matrices
N = size(x,2);
state_dim = size(x,1);

res = sqrt(sum(sum(((x - y).^2)./state_dim,1))/N);

    
end

