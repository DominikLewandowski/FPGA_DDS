%put this file in the same folder as the 'signal_output.txt' in order to
%work
clc, close all
signal=readmatrix('signal_output.txt');


figure;
plot(1:length(signal),signal, 'LineWidth', 1.5);
x=xlabel('Sample number [n]');
set(x,'FontSize',15)
y=ylabel('Signal amplitude [mV]');
set(y,'FontSize',15)
grid on;