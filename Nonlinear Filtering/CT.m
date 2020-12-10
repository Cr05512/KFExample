function [x_CT,P_CT,X,X_prop] = CT(fun,x,P,w,noiseCov,k,T)

X = computeThirdDegCubatureSet(x,P);
X_prop = cell2mat(arrayfun(@(i) fun(X(:,i),k,T), 1:size(X,2),'UniformOutput',false));
[x_CT,P_CT] = computeMomentsFromSamples(w,X_prop);
P_CT = P_CT + noiseCov;

end

