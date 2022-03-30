%% encoder
clear; clc;

[sample, Fs] = audioread("sample.wav"); % sample audio is read
sample = sample(0.9*Fs:3*Fs); % sample audio is truncated

t_win = 0.025; % window length in s
t_hop = 0.01; % how length in s

n_win = floor(t_win*Fs); % window length in samples
n_shift = floor(t_hop*Fs); % shift length in samples

win = hamming(n_win, "periodic"); % window

p = 50; % prediction order
n_frames = floor((length(sample)-n_win) / n_shift)+1; % calculate the number of frames

A = zeros(n_frames, p); % holds poles of each frame
pitches = zeros(n_frames, 1); % holds the pitch values of each frame
types = zeros(n_frames, 1); % holds if the frame is voiced
gains = zeros(n_frames, 1);

for i = 1:n_frames % each frame

    windowed = sample((i-1)*n_shift+1:(i-1)*n_shift+n_win) .* win; % apply hamming window
    
    % autocorrelation of frame
    acf = xcorr(windowed); 
    acf = acf(n_win:end);

    a = lpc(acf, p); % LP coefficients are found
    A(i, :) = a'; % LP coefficients for each frame are stored

    pitches(i) = pda(acf, Fs); % pitch is calculated using first approach
%     pitches(i) = pda2(windowed, a, Fs); % pitch is calculated using second approach
    types(i) = get_type(windowed); % type is calculated
    gains(i) = get_gain(types(i), acf, a, Fs, pitches(i)); % gain is calculated    
    
end

%% decoder
decoded = zeros(length(sample), 1); % decoded signal is initialied
for i = 1:n_frames % each frame

    switch types(i)
        case 2 % if type is silence
            input = zeros(n_win, 1); % input is zeros
        case 1 % if type is unvoiced
            input = randn(n_win, 1); % input is random noise
        otherwise % if type is voiced
            % input is impulse train
            input = zeros(n_win, 1); 
            input(1:floor(Fs/pitches(i)):end) = 1;
    end

    output = filter(gains(i), [1, -A(i, :)], input); % input signal is filtered by using gain and poles

    % overlap and add
    decoded((i-1)*n_shift+1:(i-1)*n_shift+n_win) = decoded((i-1)*n_shift+1:(i-1)*n_shift+n_win) + win.*output;
end
decoded = decoded/max(decoded); % decoded speech is normalized

% input and output speech signals are decoded
n = length(sample);
x = linspace(0, n/Fs, n);
subplot(2, 1, 1);
plot(x, sample);
title("Input Signal");
xlabel("Time (s)");
xlim([0, n/Fs]);
grid on;

subplot(2, 1, 2);
plot(x, decoded);
title("Output Signal");
xlabel("Time (s)");
xlim([0, n/Fs]);
grid on;



