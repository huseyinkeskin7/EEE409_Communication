clc; clear; close all;

% Parameters
numBits = 1e6;                     % Total number of bits to process
SNR_dB = 0:12;                     % SNR values in dB
SNR_linear = 10.^(SNR_dB / 10);    % Convert SNR from dB to linear scale
poly = [1 1 1 0 1];
init = [1 0 1 1];        

% Initialize BER arrays
BER_Bob = zeros(1, length(SNR_dB));  % BER for the legitimate user (Bob)
BER_Eve = zeros(1, length(SNR_dB));  % BER for the eavesdropper (Eve)

% Loop over SNR values
for idx = 1:length(SNR_linear)

    M = 2;            
    scramblerObj = comm.Scrambler(M, poly, init);     
    descramblerObj = comm.Descrambler(M, poly, init); 

    % Step 1: Generate random binary input data
    inputData = randi([0 1], 1, numBits);  % Random binary sequence (0s and 1s)
    
    % Step 2: Apply scrambling using the LFSR-based scrambler
    scrambledData = step(scramblerObj, inputData')'; % Scrambled sequence
    
    % Step 3: Map the binary sequence to BPSK symbols (0 -> -1, 1 -> +1)
    modulatedData = 2 * scrambledData - 1;  % BPSK modulation
    
    % Step 4: Add Gaussian noise to the transmitted signal
    noisePower = 1 / (2 * SNR_linear(idx));         % Noise power based on SNR
    noisySignal = modulatedData + sqrt(noisePower) * randn(1, numBits); % AWGN
    
    % Step 5: Detection at the legitimate receiver (Bob)
    detectedDataBob = noisySignal > 0;             % Decision threshold at 0
    
    % Step 6: Descramble the detected sequence
    recoveredData = step(descramblerObj, detectedDataBob')'; % Descrambled data
    
    % Step 7: Calculate BER for the legitimate user
    BER_Bob(idx) = sum(inputData ~= recoveredData) / numBits; % Bit error rate
    
    % Step 8: Detection at the eavesdropper (Eve)
    detectedDataEve = noisySignal > 0; % Eve uses simple threshold detection
    BER_Eve(idx) = sum(inputData ~= detectedDataEve) / numBits; % BER for Eve
end

% Calculate theoretical BER for BPSK modulation in AWGN channel
BER_Theory = qfunc(sqrt(2 * SNR_linear));

% Display results in the command window
fprintf('SNR (dB)\tBER_Bob\t\tBER_Eve\tBER_Theory\n');
disp([SNR_dB' BER_Bob' BER_Eve' BER_Theory']);

% Plot BER performance on a semilogarithmic graph
figure;
semilogy(SNR_dB, BER_Bob, 'b-*', 'LineWidth', 2); hold on;    % Bob's BER: green, star markers
semilogy(SNR_dB, BER_Eve, 'r-^', 'LineWidth', 2);            % Eve's BER: magenta, triangle markers
semilogy(SNR_dB, BER_Theory, 'y-.', 'LineWidth', 2);         % Theoretical BER: cyan, dash-dot line

% Graph settings
grid on;
xlabel('SNR per bit (dB)', 'FontWeight','bold', 'FontSize', 12);
ylabel('Bit Error Rate (BER)', 'FontWeight','bold', 'FontSize', 12);
title('BER Performance of Scrambled Binary System (x^4 + x^3 + 1)', 'FontSize', 14);
legend('Legitimate User (Bob)', 'Eavesdropper (Eve)', 'Theoretical BER', 'Location', 'southwest');
