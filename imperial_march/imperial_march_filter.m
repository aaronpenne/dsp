% imperial_march_filter.m

[x,fs] = audioread('C:\home\docs\imperial_march\imperial_march_noisy.wav');
T = 1/fs;
Lbit = length(x);
Lsec = Lbit/fs;
t = linspace(0, Lsec, Lbit);
f1 = -fs/2:fs/Lbit:fs/2-fs/Lbit;

% Gets song into working variable, gets song samples before/after tone switch
x_clean = x;
a = length(x_clean(1:12*fs-1));
b = length(x_clean(12*fs:end));
x_sample1 = x_clean(1:12*fs-1);	% Sample of song from 0 to 12 secs
x_sample1 = padarray(x_sample1,[b 0],'post');
x_sample2 = x_clean(12*fs:end);	% Sample of song from 12 to end of song
x_sample2 = padarray(x_sample2,[a 0],'pre');
 
% Band Stop Filter for 132 Hz for t<12 sec
fc  = 132;				% Center frequency of noise
fd  = 25;				% Bandwidth of filter divided by 2
wc1 = fc - fd;			% Low cutoff frequency
wc2 = fc + fd;			% High cutoff frequency
wn  = [wc1 wc2]/(fs/2);		% Normalized frequencies
N   = 10000;				% Order of filter
h   = fir1(N,wn,'stop');	% Create filter
x_132 = filter(h,1,x_sample1);	% Apply filter to song
figure(1);
freqz(h,1);
 
% Band Stop Filter for 61 Hz for t>12 sec
fc  = 61;
fd  = 25;
wc1 = fc - fd;
wc2 = fc + fd;
wn  = [wc1 wc2]/(fs/2);
N   = 10000;
h   = fir1(N,wn,'stop');
x_61 = filter(h,1,x_sample2);
figure(2);
freqz(h,1);
 
% Combine two samples into one full song
x_clean = x_132 + x_61;
 
% Band Stop Filter for 1231 Hz for entire song
fc  = 1231;
fd  = 25;
wc1 = fc - fd;
wc2 = fc + fd;
wn  = [wc1 wc2]/(fs/2);
N   = 10000;
h   = fir1(N,wn,'stop');
x_clean = filter(h,1,x_clean);
figure(3);
freqz(h,1);
 
% Band Stop Filter for color noise for entire song
fc  = 3500;
fd  = 750;
wc1 = fc - fd;
wc2 = fc + fd;
wn  = [wc1 wc2]/(fs/2);
N   = 500;
h   = fir1(N,wn,'stop');
x_clean = filter(h,1,x_clean);
figure(4);
freqz(h,1);
 
% Remove pop at beginning of song by deleting first half second
x_clean(1:fs/2,1) = 0;
 
% Get fft of song after applying filters
X1 = fftshift(fft(x));  
X_clean = fftshift(fft(x_clean)); 
 
% Plot everything
figure(5);
subplot(2,1,1);stem(f1,1/Lbit*abs(X1),'filled');
title('Magnitude Spectrum of Corrupted Song');xlabel('Hz');ylabel('|X[k])|');
grid on;grid minor;axis tight;
subplot(2,1,2);stem(f1,1/Lbit*abs(X_clean),'filled');
title('Magnitude Spectrum of Clean Song');xlabel('Hz');ylabel('|X[k])|');
grid on;grid minor;axis tight;
 
figure(6);
subplot(2,1,1); plot(x);
title('Corrupted Signal - Time Domain');xlabel('sec');ylabel('x[n]');
grid on;grid minor;axis tight;
subplot(2,1,2); plot(x_clean);
title('Clean Signal - Time Domain');xlabel('sec');ylabel('x[n]');
grid on;grid minor;axis tight;
 
figure;
stem(f1,1/Lbit*abs(X_clean),'filled');
title('Magnitude Spectrum of Clean Song (Zoomed)');xlabel('Hz');ylabel('|X[k])|');
grid on;grid minor;axis tight;
 
% Create WAV and play clean song
audiowrite('C:\home\docs\school\EE556\EE556_Project05\Jason_Aaron_imperial_march_CLEAN_Fall_2014.wav',x_clean,fs);
play_clean = audioplayer(x_clean, fs);
play(play_clean);
