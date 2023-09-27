% BackInduct.m

% Parameters
Theta =0.539;
Tau =0.7802;
Beta =0.97;
kappa =-3.0835;
T    =70;
Xi =0.2;
K1   =69000;
grid =172;

K=0:grid:K1;
V=[NaN(length(K),T), zeros(length(K), 1)];

% define k 
k = (1-xi)*p(t)*h(t+1) + a(t+1);

% Loop over possible values of k_{t} and k_{t+1}
V2 = NaN(length(K), length(K), T);
for t = T:-1:1
	for inK = 1: length(K)
		for outK=1:(inK)
			c  = K(inK)-K(outK)-eta(t);
			V2(inK, outK, t)=log((theta*c(t).^tau+(1-theta)*(kappa*h(t+1)).^tau).^(1/tau))+Beta*V(outk,t+1);
		end
	end
V(:,t) =max(V2(:, :, t), [], 2);
end

% Calculate optimal results forward
vf = NaN(T,1);
cap = [K1; NaN(T,1)];
con=NaN(T,1);

for t=1:T
	vf(t) = V(find(K==cap(t)),t);
	cap(t+1)=K(find(V2(find(K==cap(t)), :, t)==vf(t)));
	con(t)=cap(t)-cap(t+1);
end

% Display and plot results
disp('   K      C')
fprintf('%3.3f %3.3f\n', cap([1:t], :), con)

subplot(2,1,1)
plot([1:1:T], [con, cap([2:T+1], :)], 'LineWidth', 2)
ylabel('Consumption, Capital', 'FontSize', 12)
xlabel ('Time', 'FontSize', 12)
legend('Consumption', 'Capital')

subplot(2,1,2)
plot([1:1:T], vf, 'Color', 'red', 'LineWidth', 2)
ylabel('Value Function', 'FontSize', 12)
xlabel('Time', 'FontSize', 12)

