function dh = jacobianMeasModel(xk_pred)
xk = sym('xk',[length(xk_pred) 1]);

h = NLMeasurementModel(xk);

dh = jacobian(h,xk);
dh = double(subs(dh,xk,xk_pred));
end

