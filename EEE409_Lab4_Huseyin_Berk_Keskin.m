%BER Performance of a  M-ary PAM system

% This graph shows how the Bit Error Rate (BER) changes with increasing SNR (dB) for 2-PAM and 4-PAM modulation schemes. According to the simulation results, 4-PAM (blue circles) has a higher error rate, while 2-PAM (red crosses) achieves a lower BER. Additionally, the analytical result for 2-PAM (yellow squares) aligns with the simulation and reaches lower error rates at high SNR values. This indicates that lower modulation orders provide better BER performance
clc
clear
close all

NT = 10^(4); %number of trials
SNR = 0 : 15; %dB
SNR_lin = (10.^(SNR/10)); %SNR values in linear scale
%===============================================
% Preallocate BER array
BER = zeros(1, length(SNR_lin));
BER_2PAM = zeros(1, length(SNR_lin));
% Generate transmitted symbols for 4-PAM: {-3, -1, +1, +3}
transmitted_symbols = [-3, -1.5, 1.5, 3];
P_s = mean(transmitted_symbols.^2); % Average power for 4-PAM


%Find the BER for different SNR values
M=4;
for i = 1 : length(SNR_lin)

    % Produce input sequence
    TX_data = transmitted_symbols(randi([1, 4], 1, NT)); % Random 4-PAM symbols

    % Generate Gaussian noise samples
    noise_variance = P_s / SNR_lin(i); % (1) Compute noise variance
    noise = sqrt(noise_variance) * randn(1, NT); % (2) Generate noise samples

    % Generate received signal (Signal + Noise)
    RX_data = TX_data + noise;

    % Data detection without functions
    detdata = zeros(1, NT); % Initialize detected symbols array
    for k = 1:NT
        if RX_data(k) < -2
            detdata(k) = -3;
        elseif RX_data(k) < 0
            detdata(k) = -1.5;
        elseif RX_data(k) < 2
            detdata(k) = 1.5;
        else
            detdata(k) = 3;
        end
    end

    % Compute BER
    num_errors = sum(TX_data ~= detdata);
    BER(i) = num_errors / NT;
end

% =========================
% M = 2 PAM System
% =========================
% Generate transmitted symbols for 2-PAM: {-1, +1}
transmitted_symbols_2PAM = [-1, 1];
P_s_2PAM = mean(transmitted_symbols_2PAM.^2); % Average power for 2-PAM

for i = 1 : length(SNR_lin)
    % Produce input sequence
    TX_data_2PAM = transmitted_symbols_2PAM(randi([1, 2], 1, NT)); % Random 2-PAM symbols

    % Generate Gaussian noise samples
    noise_variance_2PAM = P_s_2PAM / SNR_lin(i); % Compute noise variance
    noise_2PAM = sqrt(noise_variance_2PAM) * randn(1, NT); % Generate noise samples

    % Generate received signal (Signal + Noise)
    RX_data_2PAM = TX_data_2PAM + noise_2PAM;

    % Data detection for 2-PAM
    detdata_2PAM = sign(RX_data_2PAM); % Simple threshold detection at zero

    % Compute BER for 2-PAM
    num_errors_2PAM = sum(TX_data_2PAM ~= detdata_2PAM);
    BER_2PAM(i) = num_errors_2PAM / NT;
end

% Simulation Results
figure;
stem(SNR, BER);
title('BER vs. SNR in linear scale');
xlabel('SNR (dB)');
ylabel('BER');
grid on;

figure;
semilogy(SNR, BER, 'o');
axis([SNR(1) SNR(end) 10^(-8) 1]);
title('BER vs. SNR in semilog scale');
xlabel('SNR (dB)');
ylabel('BER');
grid on;
hold on;

% Analytical BER for comparison (binary PAM)
BER2 = qfunc(sqrt(SNR_lin));
semilogy(SNR, BER2);
title('Comparison of Simulation Results with Analytical Results');
legend('Simulation (M=4)', 'Analytical (M=2)');

figure;
semilogy(SNR, BER, 'o-', 'DisplayName', 'Simulation (M=4)');
hold on;
semilogy(SNR, BER_2PAM, 'x-', 'DisplayName', 'Simulation (M=2)');

% Analytical BER for comparison (binary PAM)
BER_theoretical_2PAM = qfunc(sqrt(2 * SNR_lin)); % For M=2 binary PAM
semilogy(SNR, BER_theoretical_2PAM, 's-', 'DisplayName', 'Analytical (M=2)');

title('Comparison of BER vs. SNR for M=2 and M=4 PAM');
xlabel('SNR (dB)');
ylabel('BER');
legend;
grid on;