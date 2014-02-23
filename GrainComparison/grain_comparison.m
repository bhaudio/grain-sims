% Grain Comparison
% Written by Ben Holmes

% This script compares 4 different type of grain window:
% Triangular, Gaussian, Trapezium, and Hann
% The comparison is between the time and frequency domains
% of the windows. In each sample, two grains are repeated,
% where they cannot overlap past the point where their
% summed amplitude exceeds 1 (although some cases break this). 
% The parameters used in the comparison are:

% Grain Length: Total duration for the window
% Grain Inter-duration: The time in between windows
% Offset: The offset from the first to the second grain
% Grain Amplitude: The maximum amplitude of the grains
% Test Duration: The length of the sample
% Frequency Scale: A variable to limit the frequency focus of the spectrum
% Q: The steepness of the Gaussian window

% Sampling frequency
Fs = 44100;

% Set Parameters here
% Parameters are set between 0 and 1
% And are konstant from runtime
kGrainLength = 0.5;
kGrainInter = 0.1;
kOffset = 0.5;
kGrainAmp = 1;
kTestDur = 0.1;
kFreqScale = 0.02;
kQ = 0.4;

% Parameter processing

grainLength = 0.001 * Fs * ( ( kGrainLength*49.95 ) + 0.05 );	% Range 0.05-50ms
grainInter = 1.000 * Fs * kGrainInter;	% Range 0-1000ms
trapInter = grainInter + (grainLength/3); % To prevent overlap, a minimum duration of grain/3 is required

trapOffset = ( kOffset * ( trapInter - ( grainLength / 3 ) ) ) + ( 2 * grainLength / 3); % Trapezoid follows different rules
offset = ( kOffset * grainInter ) + (grainLength/2);	% Range

offset = zeros(1,offset);
trapOffset = zeros(1, trapOffset);

freqScale = kFreqScale * 0.5; % Only focus on frequencies of half the sampling frequency

testDur = kTestDur * Fs;
envDur = linspace(0, grainLength-1, grainLength-1);

% Triangular sections
% Three seperate sections, up down and flat
triRampUp = linspace(0, kGrainAmp, grainLength/2);
triRampDown = linspace(kGrainAmp, 0, grainLength/2);

% Gaussian is just 2 sections
t0 = grainLength/2;
gaussEnv = e.^(-((kQ*50)/grainLength^2)*((envDur-t0).^2));

% Trapezoid section
% Four sections, up, down, top and bottom
trapRampUp = linspace(0, kGrainAmp, grainLength/3);
trapRampDown = linspace(kGrainAmp, 0, grainLength/3);
trapTop = zeros(1, grainLength/3) .+ kGrainAmp;

% Hann Window
hannEnv = 0.5 .* (1 - cos((2*pi*envDur)/(grainLength-1)));

% Flat section
interSpace = zeros(1, grainInter);
trapInterSpace = zeros(1, trapInter);

% Grain makeup
triGrain = [triRampUp triRampDown interSpace];
gaussGrain = [gaussEnv interSpace];
trapGrain = [trapRampUp trapTop trapRampDown trapInterSpace];
hannGrain = [hannEnv interSpace];

% Add loads of grains together
% Triangle
% First grain
triGroup1 = triGrain;
	while (size(triGroup1,2) < testDur)
		triGroup1 = [triGroup1 triGrain];
	endwhile
	triGroup1 = triGroup1(1:testDur);

% Second grain
triGroup2 = offset;
	while (size(triGroup2,2) < testDur)
		triGroup2 = [triGroup2 triGrain];
	endwhile
	triGroup2 = triGroup2(1:testDur);

% Gaussian
gaussGroup1 = gaussGrain;
	while (size(gaussGroup1,2) < testDur)
		gaussGroup1 = [gaussGroup1 gaussGrain];
	endwhile
	gaussGroup1 = gaussGroup1(1:testDur);

gaussGroup2 = offset;
	while (size(gaussGroup2,2) < testDur)
		gaussGroup2 = [gaussGroup2 gaussGrain];
	endwhile
	gaussGroup2 = gaussGroup2(1:testDur);

% Trapezoid
trapGroup1 = trapGrain;
	while (size(trapGroup1,2) < testDur)
		trapGroup1 = [trapGroup1 trapGrain];
	endwhile
	trapGroup1 = trapGroup1(1:testDur);

trapGroup2 = trapOffset;
	while (size(trapGroup2, 2) < testDur)
		trapGroup2 = [trapGroup2 trapGrain];
	endwhile
	trapGroup2 = trapGroup2(1:testDur);

% Hann
hannGroup1 = hannGrain;
	while(size(hannGroup1, 2) < testDur)
		hannGroup1 = [hannGroup1 hannGrain];
	endwhile
	hannGroup1 = hannGroup1(1:testDur);

hannGroup2 = offset;
	while(size(hannGroup2, 2) < testDur)
		hannGroup2 = [hannGroup2 hannGrain];
	endwhile
	hannGroup2 = hannGroup2(1:testDur);

% Join them together
triGroupSum = triGroup1 + triGroup2;
gaussGroupSum = gaussGroup1 + gaussGroup2;
trapGroupSum = trapGroup1 + trapGroup2;
hannGroupSum = hannGroup1 + hannGroup2;

% Plot them
x = linspace(0,testDur, testDur);
waveform = sin(2*pi*50*x);
triFreqPlot = fft(triGroupSum);
gaussFreqPlot = fft(gaussGroupSum);
trapFreqPlot = fft(trapGroupSum);
hannFreqPlot = fft(hannGroupSum);

% Triangle Plot
% Time domain
subplot(2,4,1);
plot(x/Fs, triGroupSum, '-k');
hold on;
plot(x/Fs, triGroup1, '--b');
hold on;
plot(x/Fs, triGroup2, '--r');
axis([0 kTestDur 0 1.2]);
legend('Joined Envelope', 'First Grain', 'Second Grain');
title(" Triangle Time Domain ", 'FontSize', 14);
xlabel("Time (s) ->", 'FontSize', 14);
ylabel("Amplitude", 'FontSize', 14);
hold off;

% Frequency domain
subplot(2,4,5);
plot(x*Fs/testDur, abs(triFreqPlot), '-k');
axis([0 Fs*freqScale 0 max(triFreqPlot)]);
title(" Triangle Frequency Response ", 'FontSize', 14);
xlabel("Frequency(Hz)", 'FontSize', 14);
ylabel("Amplitude", 'FontSize', 14);

% Gaussian Plot
% Time domain
subplot(2,4,2);
plot(x/Fs, gaussGroupSum, '-k');
hold on;
plot(x/Fs, gaussGroup1, '--b');
hold on;
plot(x/Fs, gaussGroup2, '--r');
axis([0 kTestDur 0 1.2]);
legend('Joined Envelope', 'First Grain', 'Second Grain');
title(" Gaussian Time Domain ", 'FontSize', 14);
xlabel(" Time (s) -> ", 'FontSize', 14);
ylabel(" Amplitude ", 'FontSize', 14);
hold off;

% Frequency Domain
subplot(2,4,6);
plot(x*Fs/testDur, abs(gaussFreqPlot), '-k');
axis([0 Fs*freqScale 0 max(gaussFreqPlot)]);
title(" Gaussian Frequency Domain ", 'FontSize', 14);
xlabel(" Frequency (Hz) ", 'FontSize', 14);
ylabel(" Amplitude ", 'FontSize', 14);

% Trapezoid Plot
subplot(2,4,3);
plot(x/Fs, trapGroupSum, '-k');
hold on;
plot(x/Fs, trapGroup1, '--b');
hold on;
plot(x/Fs, trapGroup2, '--r');
axis([0 kTestDur 0 1.2]);
legend('Joined Envelope', 'First Grain', 'Second Grain');
title(" Trapezoid Time Domain ", 'FontSize', 14);
xlabel(" Time (s) -> ", 'FontSize', 14);
ylabel(" Amplitude ", 'FontSize', 14);
hold off;

subplot(2,4,7);
plot(x*Fs/testDur, abs(trapFreqPlot), '-k');
axis([0 Fs*freqScale 0 max(trapFreqPlot)]);
title(" Trapezoid Frequency Domain ", 'FontSize', 14);
xlabel(" Frequency (Hz) ", 'FontSize', 14);
ylabel(" Amplitude ", 'FontSize', 14);

% Hann Plot
subplot(2,4,4);
plot(x/Fs, hannGroupSum, '-k');
hold on;
plot(x/Fs, hannGroup1, '--b');
hold on;
plot(x/Fs, hannGroup2, '--r');
axis([0 kTestDur 0 1.2]);
legend('Joined Envelope', 'First Grain', 'Second Grain');
title(" Hann Time Domain ", 'FontSize', 14);
xlabel(" Time (s) -> ", 'FontSize', 14);
ylabel(" Amplitude ", 'FontSize', 14);
hold off;

subplot(2,4,8);
plot(x*Fs/testDur, abs(hannFreqPlot), '-k');
axis([0 Fs*freqScale 0 max(hannFreqPlot)]);
title(" Hann Frequency Domain ", 'FontSize', 14);
xlabel(" Frequency (Hz) ", 'FontSize', 14);
ylabel(" Amplitude ", 'FontSize', 14);
