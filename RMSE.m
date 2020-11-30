function result = RMSE(x,y)
n = size(x,1);
err = x-y;
errS = sum(err,1).^2 / n;
result = sqrt(errS);
end

