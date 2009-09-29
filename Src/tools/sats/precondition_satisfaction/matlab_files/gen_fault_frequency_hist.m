%Generating the fault detection frequency histogram for the or-strategy and
%the ps-strategy.

f = figure;
subplot(2, 1, 1);
orss = ors (find(ors > 0));
[nor, orout] = hist (orss / 30, [0:0.03333:1]);
ss = size (orss);
nor = nor / ss(1) * 100;
bar(orout, nor);
%hist(ors / 30, [0:0.0333:1]);
ylim([0, 40]);
xlim([0, 1.03]);
ylabel('% group-wise faults');
xlabel('(a) Detection probability: or-strategy');
h = findobj(gca,'Type','patch');
set(h(1),'FaceColor', [0.8 0.5 0.4]);
set(gca,'FontSize', 12);

subplot(2, 1, 2);
psss = pss (find(pss>0));
ss = size(psss);
[nps, psout] = hist (psss / 30, [0:0.03333:1]);
nps = nps / ss(1) * 100;
bar (psout, nps);
%hist(pss / 30, [0:0.0333:1]);
ylim([0, 40]);
xlim([0, 1.03]);
ylabel ('% group-wise faults');
xlabel('(b) Detection probability: ps-strategy')

h = findobj(gca,'Type','patch');
set(gca,'FontSize', 12);
set(h(1),'FaceColor', [0.8 0.5 0.4]);
saveas(f, 'fault_frequency.eps', 'eps');

%Calculate covariance between the or-strategy and the ps-strategy.
