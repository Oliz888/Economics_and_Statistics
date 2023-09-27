for t= T:-1:1
for ink=1:length(K)
for outK=1:(ink)
c=K(ink)-K(outK);
V2(ink, outK, t)=log(c)+Beta*V(outK,t+1);
end
end
V(:,t)=max(V2(:,:,t),[],2);
end

vf = NaN(T,1);
cap = [K1; NaN(T,1)];
con = NaN(T,1);

for t = 1:T
    vf(t)=V(find(K==cap(t)),t);
    cap(t+1)=K(find(V2(K==cap(t)),:,t)==vf(t)));
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