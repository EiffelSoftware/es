y = [ors, pss, pss-ors];
y = y ./ 30;
y = sortrows(y, -3);

fidgtzeroor = find(y(:,1)>0);
fidgtzerops = find(y(:,2)>0);

modor = y(:,3);
modor(fidgtzerops) = 0;
modps = y(:,3);
modps(fidgtzeroor) = 0;

f = figure;
set(gca,'FontSize', 12);
hold on;
bar(y(:,3), 'edgecolor', 'y', 'facecolor', 'y');
bar(modor, 'edgecolor', 'r', 'facecolor', 'r');
bar(modps, 'edgecolor', 'g', 'facecolor', 'g');
plot(y(:,3), 'b-', 'linewidth', 2);
xlim([0 size(y,1)]);
hline(0, 'k-');
xlabel('Faults');
ylabel('Difference of fault detection probability');
h = legend({'both strategies' 'or-strategy only' 'ps-strategy only'});
set(get(h,'title'),'String','Faults detected by:');
set(get(h,'title'),'FontSize',12);
saveas(f, 'fault_frequency_comparison', 'png');
saveas(f, 'fault_frequency_comparison', 'epsc2');
%saveas(f, 'fault_frequency_comparison', 'eps');
hold off;
close(f);