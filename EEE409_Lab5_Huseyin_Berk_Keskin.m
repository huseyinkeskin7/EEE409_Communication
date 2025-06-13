%%%%% Design and Simulation of a 4-PAM Baseband Communication System
clc
clear
close all

%%%%% System Parameters
M = 4; % Modulation order (4-PAM)
T = 1; % Receiver sampling time
ts = 0.1; % Sampling time for pulse shaping
total_symbols = 10000; % Number of symbols for transmission (for SER accuracy)
SNR_dB_range = 0:2:24; % SNR range in dB for SER evaluation

%%%%% Raised Cosine Filter Parameters
alpha = 0.75; % Roll-off factor
t = -4*T : ts : 4*T; % Pulse duration
g = rc(t, alpha); % Generate raised cosine pulse

%%%%% Generating 4-PAM Data
data = randi([0, M-1], [1, total_symbols]); % Generate random 4-PAM data
TX_data = 2 * data - (M - 1); % Map data to 4-PAM levels (-3, -1, 1, 3)
TX_signal = upsample(TX_data, T/ts); % Upsample data for pulse shaping
g_TX = conv(TX_signal, g); % Transmitted signal after pulse shaping

%%%%% Monte Carlo Simulation for SER Calculation
SER_simulated = zeros(1, length(SNR_dB_range)); % Initialize simulated SER
SER_theoretical = zeros(1, length(SNR_dB_range)); % Initialize theoretical SER

for i = 1:length(SNR_dB_range)
    SNR_dB = SNR_dB_range(i);
    SNR = 10^(SNR_dB / 10);
    sigma = sqrt(1 / (2 * SNR)); % Noise standard deviation for given SNR

    % Generate noise and add to transmitted signal
    noise = sigma * randn(1, length(g_TX));
    g_RX = g_TX + noise; % Received signal with noise

    % Receiver Processing
    L_initial = 4 * T / ts; % Initial position after convolution
    L_final = length(g_RX) - L_initial - 1; % Final position
    gg_RX = g_RX(L_initial:L_final); % Select valid received signal samples

    % Downsample to get the symbol samples at symbol timing
    sampled_data = gg_RX(1:T/ts:end);

    % Detection using specified decision boundaries
    detectedSymbols = zeros(1, total_symbols); % Initialize detected symbols array
    for k = 1:total_symbols
        if sampled_data(k) < -1.5 
            detectedSymbols(k) = -3; % Map to -3
        elseif sampled_data(k) < 0  
            detectedSymbols(k) = -1; % Map to -1
        elseif sampled_data(k) < 1.5  
            detectedSymbols(k) = 1;  % Map to 1
        else  
            detectedSymbols(k) = 3; % Map to 3
        end
    end

    % Calculate Symbol Errors
    SER_simulated(i) = sum(detectedSymbols ~= TX_data) / total_symbols;

    % Theoretical SER for 4-PAM
    SER_theoretical(i) = 3/2 * qfunc(sqrt((4/5) * SNR));
end


%%%%% Plotting Results
figure;
hold on;
semilogy(SNR_dB_range, SER_theoretical, 'b-o', 'LineWidth', 1.5); % Plot theoretical SER
hold on;
semilogy(SNR_dB_range, SER_simulated, 'r-s', 'LineWidth', 1.5); % Plot simulated SER
grid on;
xlabel('SNR (dB)');
ylabel('Symbol Error Rate (SER)');
legend('Theoretical SER', 'Simulated SER');
title('SER Performance of 4-PAM System with Raised Cosine Filter');

%%%%% Explanation
% As SNR increases, the effect of noise reduces, resulting in a lower SER.
% At low SNR values, noise significantly impacts the signal, causing more
% errors and hence a higher SER. The theoretical SER curve is smoother,
% and as SNR increases, the
