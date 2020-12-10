function [x_UT,P_UT,X,X_prop] = UT(fun,x,P,w,lambda,noiseCov,k,T)

X = computeSigmaPoints(x,P,lambda);
X_prop = cell2mat(arrayfun(@(i) fun(X(:,i),k,T), 1:size(X,2),'UniformOutput',false));
[x_UT,P_UT] = computeMomentsFromSamples(w,X_prop);
P_UT = P_UT + noiseCov;

end

