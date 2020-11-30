function [x,P] = computeMomentsFromSamples(w,Samples)

m = size(Samples,2);
x = zeros(size(Samples,1),1);
P = zeros(size(Samples,1),size(Samples,1));

for i=1:m
    x = x + w(i)*Samples(:,i);
end

for i=1:m
    P = P + w(i)*(Samples(:,i) - x)*(Samples(:,i)-x)';
end

end

