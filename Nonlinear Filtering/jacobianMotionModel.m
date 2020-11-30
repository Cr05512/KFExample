function df = jacobianMotionModel(xk_est,k,T)
xk = sym('xk',[length(xk_est) 1]);

f = NLMotionModel(xk,k,T);

df = jacobian(f,xk);
df = double(subs(df,xk,xk_est));
end

