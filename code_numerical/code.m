% BackInduct.m

% Parameters: preferences
beta = 0.97 ;         % Time discount factor 
gamma = 2.56 ;        % Degree of alturism 
sigma= 1 ;            % Intertemporal elasticity of subset 
g  = 7.24 ;         % Service flow from housing stock 
theta = 0.539;        % consumption share in utility function
tau  = 0.782;        % elasticity of sub. between c,h 
e.^kappa = 0.31:1.28; % domain of the preference shocks (check)

% parameters: housing and Financial Markets
phi = 0.06;       % Transaction cost 
xi = 0.2;          % Down-payment requirement 
r = 0.01 ;          % Return on financial assets 
rm = 0.0724;         % Mortgage interest rate  
rho = 0.0724;         % Rental rate of housing 
pirho = 0.95;         % Persistence of house price shock 
sigmarho = 0.1;        % Std. dev. of house price shock 


% parameters: labor income process
pieta = 0.95          % Persistence of income shock 
sigmaeta = 0.3         % Std. dev. of income shock 

% set the variables to their values in the dataset
household_data = readmatrix('data/.csv');
o1 = household_data("rent/own");
h1 = household_data("house_size");
l1 = household_data("rent_size");
p1 = household_data("mortgage_principal");
a1 = household_data("financial_asset");

%%% Update exogenous state variables (income, home prices, interest rates).


% income process: a random effects model with AR(1) error term, for the
% simulation purpose, transform the random effects into imputed fixed
% effects.
tdist = struct('Name','at','DoF',69);
Mdl = arima(1,0,0)


%simulate interest rate (rt) and home price inflation (piet) as VAR with one
%lag to obtain pt
r_init = household_data("initial_interest_rate")
piet_init = 0;
numseries = 2;
p =1;
Mdl = varm(numseries,p);
seriesnames = {'rt','piet'};
pt= (1+piet)*p;


% update home equity choice due to home price change and nonhousing wealth
% due to interest accumulation to obtain qt
qt = at +0.8*ht*p(t-1)
 

% construct the transition probability matrix to obtain P
P = [];
    P = sparse(zeros(4,T));
    for j= 1:3
    P(alpha(1), 0) = cdf(alpha(1) -F(s(it);beta))-cdf(0-F(s(it);beta));
    P(alpha(2), alpha(1)) = cdf(alpha(2) -F(s(it);beta))-cdf(alpha(1)-F(s(it);beta));
    P(alpha(3), alpha(2)) = cdf(alpha(3) -F(s(it);beta))-cdf(alpha(2)-F(s(it);beta));
    P(1, alpha(3)) = cdf(1 -f(ik))-cdf(alpha(3)-F(s(it);beta));
    end
    P = [P;Pk];

%%% Solving Discrete DPs by Bellman Equation
% enter the model parameters and construct the state and action spaces


% define the period utility function for owner and renter respectively
if h(t+1)>0
    u(c,g(d))=log[(theta*c^(tau)+(1-theta)(kappah*h')^(tau))^((1)/(tau))];
else
    u(c,g(d))=log[(theta*c^(tau)+(1-theta)(l)^(tau))^((1)/(tau))];
end

% construct bellman equation and rectangular grid for each period to search
% for optimal （q'，h'）       
for t= 70:-1:1
    for inq=1:length(Q)
        for outq=1:(inq)
            h=Q(inq)-Q(outq);
            V2(inq, outq, t)=u(c, g(d)) + P*beta*V(outq, eta', q', h', p, p', t+1);
        end
    end
    V(:,t)=max(V2(:,:,t),[],2);
end

% Calculate optimal results forward
vf = NaN(T,1);
equity = [q1; NaN(T,1)];
house = NaN(T,1);
for t = 1:T
    vf(t)=V(find(Q==equity(t))),t);
    equity(t+1)=Q(find(V2(q==cap(t)),:,t)==vf(t)));
    house(t)=equity(t)-equity(t+1);
end

% Display and plot results
disp('   q      h')
fprintf('%3.3f %3.3f\n', equity([1:t], :), house)

subplot(2,1,1)
plot([1:1:T], [con, cap([2:T+1], :)], 'LineWidth', 2)
ylabel('House, Equity', 'FontSize', 12)
xlabel ('Time', 'FontSize', 12)
legend('House', 'Equity')

subplot(2,1,2)
plot([1:1:T], vf, 'Color', 'red', 'LineWidth', 2)
ylabel('Value Function', 'FontSize', 12)
xlabel('Time', 'FontSize', 12)

% compute consumption through budgets constraint
c(t)+a(t+1)+p(t)*h(t+1)+p(t)*phi(h(t+1),h(t))= eta*epsi(t)+(1+r(t)(a))*a(t)+p(t)*h(t)




