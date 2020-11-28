function df = jacobianMotionModel(xk_est,k)
syms xk

f = NLMotionModel1D(xk,k);

df = diff(f,xk);
df = double(subs(df,xk,xk_est));
end

