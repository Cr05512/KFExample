function [ratio,Nq_bar,Ir] = NISTest(nis_vec,m)
%When no real values for state are available, we can check consistency of
%the filter through a statistical test on innovations called Normalized
%Innovation Squared, which tests for the unbiasedness of the filter.
%If the filter assumptions are met then the nis are
%each chi squared in m degrees of freedom, where m = 2 in our case

%Compute the confidence interval
N = length(nis_vec);
Ir = [chi2inv(0.025,N*m);chi2inv(0.975,N*m)];

thresh = chi2inv(0.95,m);

inRange = nis_vec<=thresh;

ratio = sum(inRange)/length(nis_vec);
Nq_bar = sum(nis_vec);

if Nq_bar<=Ir(2) && Nq_bar>=Ir(1)
    disp(strcat(['The filter is consistent: ',num2str(Nq_bar),' in a range: [',num2str(Ir(1)),',',num2str(Ir(2)),']']));
end

%disp(strcat(['NIS ratio: ',' ',num2str(ratio*100),'%']));


end

