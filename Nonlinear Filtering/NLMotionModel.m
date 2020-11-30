function x_next = NLMotionModel(x,k,T)
%Nonlinear motion model
x_next = 0.5*x + 25*x./(1 + x.^2) + 8*cos(1.2*((k-1)*T));

end

