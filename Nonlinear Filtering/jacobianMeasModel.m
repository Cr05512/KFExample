function dh = jacobianMeasModel(xk_pred)
syms xk

h = NLMeasurementModel1D(xk);

dh = diff(h,xk);
dh = double(subs(dh,xk,xk_pred));
end

