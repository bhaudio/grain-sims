% Gaussian Example
% Written by Ben Holmes

% This script shows a very basic example from Dennis Gabor's paper
% Theory of Communication: the elementary signal. This signal is
% a Gaussian envelope applied to a sine wave, making the most 
% simple (elementary) grain

% a = amplitude/shape
% t = time
% t0 = centre time

% Sampling Frequency
Fs = 44100;

% Linear time vector
t = linspace(0, Fs, Fs);

% Signal properties
a = 5/Fs;
t0 = 0.5*Fs;
f0 = 6;

% Sine wave
sine = sin(2*pi*(f0/Fs)*t);

% Envelope
env = e.^(-(a^2)*((t-t0).^2));

% Plot Sine wave
subplot(1,3,1);
plot(t/Fs, sine);
title('Harmonic Oscillation', 'FontSize', 14);
ylabel("Amplitude ->", 'FontSize', 14);
xlabel("Time (s) ->", 'FontSize', 14);

% Plot Amplitude Envelope
subplot(1,3,2);
plot(t/Fs, env);
title('Probability Function (Window)', 'FontSize', 14);
ylabel("Amplitude ->", 'FontSize', 14);
xlabel("Time (s) ->", 'FontSize', 14);

% Plot the product Elementary Signal
subplot(1,3,3);
plot(t/Fs, sine.*env);
title('Elementary Signal', 'FontSize', 14);
ylabel("Amplitude ->", 'FontSize', 14);
xlabel("Time (s) ->", 'FontSize', 14);