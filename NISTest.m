function [Nq_bar,Ir] = NISTest(nis_vec,alpha,m)
%When no real values for state are available, we can check consistency of
%the filter through a statistical test on innovations called Normalized
%Innovation Squared, which tests for the unbiasedness of the filter.
%A filter is consistent if the mean estimate error is zero and the computed error
%estimate covariance is exactly the covariance of the estimate error.
%The consistency criteria of a filter are as follows:
% (a) The state errors should be acceptable as zero mean and have magnitude
%     commensurate with the state covariance as yielded by the filter.
% (b) The innovations should also have the same property.
% (c) The innovations should be acceptable as white. 
%The last two criteria are the only ones that can be tested in applications with
%real data. 
%The first criterion, which is the most important is called normalized
%(state) estimation error squared (NEES), but it can be used only in
%simulations.



%Compute the confidence interval
p_vals = [(1-alpha)/2;(1+alpha)/2];
N = length(nis_vec);
Ir = [chi2inv(p_vals(1),N*m);chi2inv(p_vals(2),N*m)];

Nq_bar = sum(nis_vec);

if Nq_bar<=Ir(2) && Nq_bar>=Ir(1)
    disp(strcat(['The filter is consistent: ',num2str(Nq_bar),' in a range: [',num2str(Ir(1)),',',num2str(Ir(2)),']']));
end

%disp(strcat(['NIS ratio: ',' ',num2str(ratio*100),'%']));



end

