function w = computeWeights(n,lambda)
w0 = lambda/(lambda + n);

w = [w0;ones(2*n,1)*0.5/(lambda + n)];
end

